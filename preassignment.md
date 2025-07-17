# Orientation Preassignment (August 20, 21, 26)

This is a **long** preassignment that involves lots of software installation and testing. Please leave a total of at least **2 hours** to complete this preassignment. That may seem like a long time, but once you've done it you'll have a powerful suite of software that you can use through your career at MIT and beyond. 

**If You Encounter Problems**
1. If you receive an error message, first try Googling it, or ChatGPT, or ask your classmates!
2. If you tried that and couldn't solve it, write an email to `leverest@mit.edu` and `seanlo@mit.edu` describing the problem in as much detail as possible, preferably including screenshots.


# 1. Optimization: Julia and JuMP

**Please try to complete the steps below before the first day of class.**  We will only be using Julia and Gurobi on the second day, but we have very limited time in class and we will not be able to help you with installation problems during the teaching time. If you have difficulties with the installations below, please email Sean (`seanlo@mit.edu`) and include as much information as possible so that we can assist you.

*Note that you will need to be connected to the MIT network to activate the Gurobi installation, but the other steps can be completed from any location.* 

## Install Julia

Julia is programming language developed at MIT. To install Julia, go to [`https://julialang.org/downloads/`](https://julialang.org/downloads/) and download the appropriate version for your operating system. We recommend installing the Juliaup installation manager, which will automaticall install Julia and allow you to maintain multiple versions of Julia on the same device. See [`here`](https://julialang.org/downloads/platform/) for more detailed instructions.

We will assume that everyone has installed the most recent version of Julia (v1.11). If you have an older version installed, we recommend that you install the newer version as well.
To confirm that Julia is installed, open a Julia window by either running `julia` in the terminal or clicking on the Julia icon in your applications menu. You should see a prompt at the bottom of the new window that looks like this:

```
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.11.6 (2025-07-09)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |
julia>
```

Type 1+1 after the prompt and press enter/return.
```julia
julia> 1+1
2
```
If you see the response above, Julia is working!

## Install JuMP

JuMP is a Julia package that we will use to create optimization models in class. To install this package, run the following lines in the Julia window:
```julia
julia> using Pkg
julia> Pkg.add("JuMP")
```

This might take quite a while to finish, so don’t worry if it looks like nothing is happening in the Julia window. You will know that the process is complete when you see the command prompt (julia>) appear at the bottom of your screen.

To test if the package is installed correctly, run the following commands:
```julia
julia> using JuMP
julia> model = Model()
```
You should see the output below:

```
A JuMP Model
Feasibility problem with:
Variables: 0
Model mode: AUTOMATIC
CachingOptimizer state: NO_OPTIMIZER
Solver name: No optimizer attached.
```

## Install IJulia and Jupyter

Jupyter is a free, open-source program that will allow us to write and run Julia code in a web browser (instead of typing everything into the command line). IJulia is a Julia package that allows Julia to communicate with the Jupyter software. Instead of installing Jupyter on its own, we can use the IJulia package to install it within Julia.

Run the following lines in a Julia window:

```julia
julia> using Pkg
julia> Pkg.add("IJulia")
julia> using IJulia
```

These lines download and install the IJulia package. 
Now, we will try to open a Jupyter notebook. If Jupyter is not installed, Julia will ask if we want to install it now. Run the following line, and then press enter/return or y to install Jupyter:
```julia
julia> notebook()
install Jupyter via Conda, y/n? [y]: 
```

If this is successful, a Jupyter tab will open in the default browser on your computer. Click “New” in the top right corner to make a new notebook (if a menu appears, select Julia 1.11). A new tab will open with a blank Jupyter notebook.


## Install Gurobi
*Note: you must be on the MIT network to activate your academic license. We will leave time at the end of day 1 of orientation for you to complete these steps. If you will not be on campus during orientation, you can use a different solver instead without a license--see notes below.*

Gurobi is a commercial optimization solver that we will use to solve optimization problems in class. Here are the basic steps that you will need to follow to install Gurobi,: 

1. Register for a Gurobi account on the [Gurobi website](https://www.gurobi.com). Use your @mit.edu email address, and select the Academic option (not the commercial option).
2. Download the Gurobi Optimizer software [`here`](https://www.gurobi.com/downloads/) and install. You might need to log in to the page first, the current stable version is Gurobi 11.0.3.
3. Create and download an Academic License to use the software [`here`](https://www.gurobi.com/downloads/end-user-license-agreement-academic/).
4. Use the license file to activate the Gurobi software that you installed. Follow the instructions on the license page to run the `grbgetkey` command. **Note that you must be connected to the MIT SECURE network to do this.**

A summary of the Gurobi installation/activation process is available [`here`](https://www.gurobi.com/academia/academic-program-and-licenses/) and detailed installation instructions are available [`here`](https://www.gurobi.com/documentation/quickstart.html). If you get stuck trying to follow these instructions, please email us for assistance.

After installing Gurobi, we need to add a Julia package called `Gurobi.jl` that allows Julia to communicate with the Gurobi software. Run the following lines in your Julia window:
```julia
julia> using Pkg
julia> Pkg.add("Gurobi")
```

If the Gurobi package is successfully installed in Julia, run the following lines:
```julia
julia> using JuMP, Gurobi
julia> model = Model(Gurobi.Optimizer)
```

You should see this output:

```
Academic license - for non-commercial use only - expires 2026-XX-XX
A JuMP Model
├ solver: Gurobi
├ objective_sense: FEASIBILITY_SENSE
├ num_variables: 0
├ num_constraints: 0
└ Names registered in the model: none
```


### Optional: Gurobi Error in Julia
If you see an error message during this installation, you can try a [manual install](https://github.com/jump-dev/Gurobi.jl?tab=readme-ov-file#manual-installation) of Gurobi (without installing `Gurobi_jll`):
```julia
# On Windows, this might be
ENV["GUROBI_HOME"] = "C:\\Program Files\\gurobi1203\\win64"
# ... or perhaps ...
ENV["GUROBI_HOME"] = "C:\\gurobi1203\\win64"
# On Mac, this might be
ENV["GUROBI_HOME"] = "/Library/gurobi1203/macos_universal2"

# Opt-out of using Gurobi_jll
ENV["GUROBI_JL_USE_GUROBI_JLL"] = "false"

import Pkg
Pkg.add("Gurobi")
Pkg.build("Gurobi")
```

**Note: check the version of Gurobi that you downloaded. The above instructions assume you downloaded version 12.0.3. If you have
a different version, your path may differ (e.g. for Gurobi 11.0.3, replace `gurobi1203` with `gurobi1103`). 
If this doesn't work, also check which folder you installed Gurobi in, and update the path accordingly if necessary.**


### Optional: Alternative to Gurobi
If you are unable to activate your Gurobi license (i.e. if you are not yet on campus), you can use an open-source solver as a temporary solution. See [here](https://jump.dev/JuMP.jl/stable/installation/#Supported-solvers) for a list of possible solvers; we will proceed with the open-source solver `HiGHS`. This will be the backend mixed-integer optimization solver for our optimization problems.

```julia
julia> using JuMP, HiGHS
julia> model = Model(HiGHS.Optimizer)
```

You should see this output: 
```julia
A JuMP Model
Feasibility problem with:
Variables: 0
Model mode: AUTOMATIC
CachingOptimizer state: EMPTY_OPTIMIZER
Solver name: HiGHS
```



## Final Check

Once you have completed all the steps above, copy and paste the following code into a new Jupyter notebook (next to the "In []:" prompt)

```julia
using JuMP, Gurobi # or using JuMP, HiGHS
model = Model(Gurobi.Optimizer) # or model = Model(HiGHS.Optimizer)
@variable(model, x >= 0)
@objective(model, Min, x)
optimize!(model)
```

Now, click the "Run" button to run this code. You should see output similar to the below (for Gurobi):

```
CPU model: Apple M2 Pro
Thread count: 12 physical cores, 12 logical processors, using up to 12 threads

Optimize a model with 0 rows, 1 columns and 0 nonzeros
Model fingerprint: 0x84abb838
Coefficient statistics:
  Matrix range     [0e+00, 0e+00]
  Objective range  [1e+00, 1e+00]
  Bounds range     [0e+00, 0e+00]
  RHS range        [0e+00, 0e+00]
Presolve removed 0 rows and 1 columns
Presolve time: 0.00s
Presolve: All rows and columns removed
Iteration    Objective       Primal Inf.    Dual Inf.      Time
       0    0.0000000e+00   0.000000e+00   0.000000e+00      0s

Solved in 0 iterations and 0.00 seconds (0.00 work units)
Optimal objective  0.000000000e+00

User-callback calls 23, time in user-callback 0.00 sec
```

Alternatively (for HiGHS):
```
Running HiGHS 1.8.0 (git hash: fcfb53414): Copyright (c) 2024 HiGHS under MIT licence terms
Coefficient ranges:
  Cost   [1e+00, 1e+00]
  Bound  [0e+00, 0e+00]
Solving LP without presolve, or with basis, or unconstrained
Solving an unconstrained LP with 1 columns
Model   status      : Optimal
Objective value     :  0.0000000000e+00
HiGHS run time      :          0.00
```

We will go through what this printed output means, but if you see something similar, everything is working correctly! If you see errors, one of the steps above may be incomplete. Feel free to email us if you have installation issues.

# 2. Version Control: Git and GitHub

How can we manage complex, code-based workflows? How can we reliably share code between collaborators without syncing issues? How can we track multiple versions of scripts without going crazy? There are multiple solutions to these problems, but *version control* with git is by far the most common. 

## Install Git

We will be using the command-line interface to Git. First of all, check if you already have git installed (in which case you can skip this step). **Windows** users should look for Git Bash, while **macOS** and **Linux** users should open a terminal and try running the command: `git`

If you don't have git installed, go to the [Git project page](https://www.git-scm.com/) and follow the link on the right side to download the installer for your operating system. Follow the instructions in the README file in the downloaded .zip or .dmg.

**Windows**: During the installation, select to use Git from the Windows command prompt, checkout Windows-style, commit UNIX-style line endings, and add a shortcut to the Desktop for easy access.

**macOS**: if you receive an “unidentified developer” warning, right-click the .pkg file, select Open, then click Open.


## Connect to GitHub.com

[GitHub](https://github.com/) is a hosting service for git that makes it easy to share your code. 


1. Sign up for an account -- remember to keep track of your username and password. Feel free to enter information about yourself and optionally a profile picture. 

2. From the menu at the top right corner of the page, go to Settings, and select SSH and GPG keys.

3. Follow the [GitHub instructions to set up SSH](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh):

	[Check if you already have SSH keys](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/checking-for-existing-ssh-keys)

	[Generate a SSH key](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) if you don’t have one

	[Add the SSH key to your account](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) 

	[Test the SSH connection](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/testing-your-ssh-connection)


**If you've made it this far, congratulations!** You now possess a powerful set of tools for analyzing data, solving optimization problems, and collaborating on code. You're ready to go!  




