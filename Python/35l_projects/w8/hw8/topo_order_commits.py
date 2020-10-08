import os, sys, zlib


#branch names with forward slashes


class CommitNode:
    def __init__(self, commit_hash):
        """
        :type commit_hash: str
        """
        self.commit_hash = commit_hash
        self.parents = set()
        self.children = set()


def find_git():
    directory = os.getcwd() #start searching at the current working directory

    while (directory != "/"):
        for item in (os.listdir(directory)):
            #target must be a folder which is named ".git"
            itempath = directory + "/" + item
            if os.path.isdir(itempath) and (item == ".git"): 
                return directory #equivalent to os.path.dirname(itempath)
        directory = os.path.dirname(directory)

    sys.stderr.write("Not inside a git repository\n")
    exit(1)

def get_branches(repos):
    refs_dir = repos + "/.git/refs/heads"
    
    #this dictionary takes the form {commit:{branches}}, where the key is a commit hash and the value is a set of branches associated with the hash
    branches = {}

    #first, get the names of all the branches in a list. We have to do this serparately because there can be branches inside of subfolders
    branch_list = []
    for branch in os.listdir(refs_dir):
        branch_path = refs_dir + "/" + branch
        if os.path.isdir(branch_path):
            for sub_branch in os.listdir(branch_path):
                branch_list.append(branch + "/" + sub_branch)
        else:
            branch_list.append(branch)
            continue
    

    #for every branch, open its correspending file and add the commit_hash/branch pair to the dictionary
    for branch in branch_list:
        branch_path = refs_dir + "/" + branch
        branch_file = open(branch_path).read()
        
        #get rid of the newline at the end of the file
        branch_location = branch_file[:-1]

        if branch_location not in branches:
            branches[branch_location] = set()
        branches[branch_location].add(branch)

    return branches



def find_commits(repos):
    obj_dir = repos + "/.git/objects"
    commits = {}
    for item in (os.listdir(obj_dir)):
        #item is the subdirectories of objects. So like "73" or "1D"
        if (item == "info" or item == "pack"):
            continue
        keys = (os.listdir(obj_dir + "/" + item))
        #print(keys)
        for obj_file in keys:
            #obj_file is the contents of these subdirectories, which are also the following 38 chars of the commit

            #the contents of obj_file are the actual contents of the commit: information on the parents, tree, and the committer/commit message
            compressed_file = open((obj_dir + "/" + item + "/" + obj_file), 'rb').read()
            decompressed_file = zlib.decompress(compressed_file).decode('utf-8','ignore')

            #we only care about the commits, not the blobs or trees
            if (decompressed_file[0] == 'c'):

                this_commit = item + obj_file
                #commits[this_commit] = decompressed_file

                #where are your parents?
                his_parents = []

                lines = decompressed_file.split("\n")      

                while(lines[1][0:6] == "parent"):
                    his_parents.append(lines[1][7:])
                    lines.pop(1)

                #TODO:
                #sometimes, the leaf node of a local branch has a "parent" which points to a remote commit. see diffutilstest for example
                #do we ignore these remote parents? How to make sure they don't get added?

                commits[this_commit] = CommitNode(this_commit)

                for parent in his_parents:
                    commits[this_commit].parents.add(parent)



    for commit in commits:
        #add all children for the parents which do exist
        for parent in (commits[commit].parents):
            if parent in commits:
                commits[parent].children.add(commit)     

    return commits

def topo_order(commits,roots):
    # create a list of all the commit lines, in order to do topological ordering
    #"topological ordering" consists of a list of topologically ordered commit lists, from least to greatest

    topo_order = []
    for vertex in roots:

        stack, visited = [(vertex, [vertex.commit_hash])], set()
        while stack:
            v, path = stack.pop()

            #if an already visited node is reached, add the path to the topo order
            if v in visited:
                path.pop(0)
                topo_order.append(path)
                continue

            visited.add(v)

            #if a final node is reached, add the path to the topo order
            if not v.children:
                topo_order.append(path)

            else:
                #the main_branch flag prevents duplicate commits from being added to the ordering.
                main_branch = True
                for child in sorted(v.children):
                    if (child not in visited) and main_branch:
                        main_branch = False
                        stack.append((commits[child], [child] + path))
                    else:
                        stack.append((commits[child], [child]))

    #transform the topological order from a list of paths to a single topological list
    #[[h5,h4,h3],[h2,h1,h0]] turns into [h5,h4,h3,h2,h1,h0]
    topo_list = []
    for topo in topo_order:
        for commit in topo:
            topo_list.append(commit)


    return topo_list

def generate_output(topo_list, commits, branches):

    output = ""
    sticky_end = False

    while topo_list:
        
        #get the first item from the list
        this_hash = topo_list.pop(0)
        
        #sticky starts happen when you start a new chain, that's not the first one
        if sticky_end:
            sticky_end = False
            #print("sticky start")
            output += "="
            for child in commits[this_hash].children:
                output += child + " "
            if output[-1] != "=":
                output = output[:-1]
            output += "\n"

        #normal print. print a commit
        output += this_hash

        #TODO:CHECK FOR BRANCHES
        #pass a branch dictionary, where setup is {commit:{branches}} for {key:value}
        if this_hash in branches:
            for branch in branches[this_hash]:
                output += " " + branch

        output += "\n"

        #sticky ends come when you reach the end of a chain, that's not the last one
        if topo_list:
            if topo_list[0] not in commits[this_hash].parents:
                #sticky end time
                sticky_end = True
                for parent in commits[this_hash].parents:
                    output += parent + " "
                output = output[:-1]
                output += "=\n\n"
        else:
            #get rid of the newline if it's the final item in the output
            output = output[:-1]

    return output


def topo_order_commits():
    repository = find_git()
    #print("Found repository at " + repository)

    local_branches_dict = get_branches(repository)

    local_commit_dict = find_commits(repository)

    #find the root commits
    root_commits = []
    for commit in local_commit_dict:
        if not local_commit_dict[commit].parents:
            root_commits.append(local_commit_dict[commit])
        else:
            for parent in (local_commit_dict[commit].parents):
                if parent not in local_commit_dict:
                    root_commits.append(local_commit_dict[commit])

    #TODO: fix the local/remote parent commit thing. 
    # I think this works now, because of the change to root_commits ^
    #print(commit_dict)

    topo_list = topo_order(local_commit_dict,root_commits)

    #topo_list = [commit for h_list in topo_lists for commit in h_list]

    #topo print works by popping the back items of the list off until they're done
    output = generate_output(topo_list,local_commit_dict,local_branches_dict)
    print(output)

if __name__ == '__main__':
    topo_order_commits()

