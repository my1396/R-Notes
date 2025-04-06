---
output: 
    bookdown::html_document2
---

# Rstudio

**Rstudio shortcuts**

Command Palette: ⇧+⌘+P, all shortcuts can be accessed via the Command Palette.

| keyboard combination | function |
|-----------------------------------|-------------------------------------|
| opt + \_ | insert assignment operator `<-` |
| ESC or ctrl + C | exit `+` prompt |
| ⇧ + ⌘ + M | Add magrittr's pipe operator "%\>%"<br />After R4.1, you can set this too native pipe `|>` |
| [ctrl + `[`/`]`]{style="color:#008B45FF"} | indent or unindent |
| cmd + D | delete one row |
| cmd + 1 | move cursor to console window |
| cmd + 2 | move cursor to editor window |
| ctrl + shift + S | add 80 hyphens `---` to signal a new chapter (Addin) |
| ctrl + shift + = | add 80 equals `===` to signal a new Chapter (Addin) |
| shift + cmd +N | new R script |
| cmd + $\uparrow$ / $\downarrow$ | in console, get a list of command history |
| shift + $\uparrow$ / $\downarrow$ | select one line up/down |
| fn + F2 | `view()` an object, don't select the object |
| cmd + shift + 1 | activate X11() window |
| [ctrl (+ shift) + tab]{style="color:#008B45FF"} | next (last) tab in scriptor (this applies to all apps); <br />hit ctrl first, then shift if necessary, last tab |

[**Source**]{style="color:#008B45FF"}

| keyboard combination | function                                            |
|----------------------|-------------------------------------------------|
| cmd + return         | Run current line/selection                          |
| opt + return         | Run current line/selection (retain cursor position) |

[**`Rmd` related**]{style="color:#008B45FF"}

| keyboard combination | function |
|---------------------|---------------------------------------------------|
| cmd + shift + K | **Knit** rmd |
| cmd + opt + C | run current code chunk in `Rmd` |
| cmd + opt + I | insert code chunks in `Rmd`, i.e., ```` ```{r} ```` and ```` ``` ```` |

------------------------------------------------------------------------

Q: How to print output in console rather than inline in Rmd?

A: Choose the gear ⚙️ in the editor toolbar and choose "Chunk Output in Console".

<img src="https://drive.google.com/thumbnail?id=1YJhzqrr4lIULXKQ-TeTHBcmR5Q-49gFe&amp;sz=w1000" alt="output to console" style="display: block; margin-right: auto; margin-left: auto; zoom:80%;"/>

------------------------------------------------------------------------

Q: How to insert Emojis in Rmd?

A: There are several options:

- You can type directly a lot of Emojis, such as ️🙏 and 🤣. Try this first, if it doesn't show properly, then try the following solutions.
    - If the emoji can show in the script, then you can use it directly.

- Using a html tag, e.g., `<span> ⚙️ </span>` will show like this 

    <p><span> ⚙️ </span> <p>
    
    This seems to be the most straightforward solution to me. ✅
    
    Note that the emoji won't disply correctly in your Rmd file, but when you render the Rmd and deploy to html pages, the emoji will show properly. 
    
- Using Hexadecimal code. (You need to look up the code somewhere, which is a hassle. ❌)

    We can add emojis to an HTML document by using their hexadecimal code. These code starts with `&#x` and ends with `;` to specify browser that these are hexadecimal codes. For example,
    
    ```html
    <p>Smily face <span>&#x1F600;</span> </p>
    ```
    will give you
    
    Smily face <span>&#x1F600;</span>
    
    Go to this site: https://emojipedia.org/emoji/

    Grab the **codepoint** for the emoji you want (e.g., `U+1F600` for grinning face)

    Replace `U+` with `&#x` so it becomes `&#x1F600`, and add a semicolon `;` at the end.

    Finally, enclose that into an html tag, e.g., `<span>`.

- With RStudio Visual mode. (You need to change mode back and forth. ❌)

    First change to the Visual mode. To insert an emoji, you can use either the `Insert` menu or the requisite markdown shortcut plus auto-complete: <img src="https://drive.google.com/thumbnail?id=19LXy8c4h2XzlSELBLCPPvOGHeKvjIDPx&amp;sz=w1000" alt="Visual Mode Emojis" style="display: block; margin-right: auto; margin-left: auto; zoom:80%;"/>
    
    I am personally NOT a fan of Visual Mode because it changes your source code silently …



------------------------------------------------------------------------

[**Set working directory**]{style="color:#008B45FF"}

``` r
# get the dir name of the current script
dir_folder <- dirname(rstudioapi::getSourceEditorContext()$path) 
setwd(dir_folder) # set as working dir
```

RStudio projects are associated with R working directories. You can create an RStudio project:

-   In a brand new directory
-   In an existing directory where you already have R code and data
-   By cloning a version control (Git or Subversion) repository

Why using R projects:

1.  I don't need to use `setwd` at the start of each script, and if I move the base project folder it will still work.
2.  I have a personal package with a custom project, which creates my folders just the way I like them. This makes it so that the basic locations for data, outputs and analysis is the same across my work.

Double-click on a `.Rproj` file to open a fresh instance of RStudio, with the working directory and file browser pointed at the project folder.

Q: What is an **R session**? And when do I use it?

A: Multiple concurrent sessions can be useful when you want to:

-   Run multiple analyses in parallel
-   Keep multiple sessions open indefinitely
-   Participate in one or more [shared projects](https://support.posit.co/hc/en-us/articles/211659737)

------------------------------------------------------------------------

**Launch a new project-less RStudio session**

``` r
# run in console
rstudioapi::terminalExecute("open -n /Applications/RStudio.app", show = FALSE)
```

`-n` Open a new instance of the application(s) even if one is already running.

`rstudioapi::terminalExecute(command, workingDir = NULL, env = character(), show = TRUE)` tells R to run the system command in quotes.

-   `command` System command to be invoked, as a character string.
-   `workingDir` Working directory for command
-   `env` Vector of name=value strings to set environment variables
-   `show` If FALSE, terminal won't be brought to front

The [`rstudioapi`]{style="color:#008B45FF"} package provides an interface for interacting with the RStudio IDE with R code. Using`rstudioapi`, you can:

-   Examine, manipulate, and save the contents of documents currently open in RStudio,
-   Create, open, or re-open RStudio projects,
-   Prompt the user with different kinds of dialogs (e.g. for selecting a file or folder, or requesting a password from the user),
-   Interact with RStudio terminals,
-   Interact with the R session associated with the current RStudio instance.

------------------------------------------------------------------------

**Set up Development Tools**

<https://cran.r-project.org/bin/macosx/tools/>

-   install Xcode command line tools

    ``` bash
    sudo xcode-select --install
    ```

-   install GNU Fortran compiler

    Using **Apple silicon** (aka arm64, aarch64, M1) Macs Fortran compiler

-   Go to <https://www.xquartz.org/>, download the .dmg and run the installer.

-   Verify that build tools are installed and available by opening an R console and running

    ``` r
    install.packages("pkgbuild")
    pkgbuild::check_build_tools()
    ```

------------------------------------------------------------------------

**Insert Code Session**

To insert a new code section you can use the **Code** -\> **Insert Section** command. Alternatively, any comment line which includes at least four trailing dashes (`-`), equal signs (`=`), or pound signs (`#`) automatically creates a code section.

**Define your own shortcuts**

<https://www.statworx.com/ch/blog/defining-your-own-shortcut-in-rstudio/>

<https://www.r-bloggers.com/2020/03/defining-your-own-shortcut-in-rstudio/>

Install the shortcut packages.

Add code session separators, `---` or `===`.

``` r
install.packages(
    # same path as above
  "~/Downloads/shoRtcut_0.1.0.tar.gz", 
  # indicate it is a local file
  repos = NULL)
install.packages(
    # same path as above
  "~/Downloads/shoRtcut2_0.1.0.tar.gz", 
  # indicate it is a local file
  repos = NULL)
```

Now go to Tools \> Modify Keyboard Shortcuts and search for "dashes". Here you can define the keyboard combination by clicking inside the empty Shortcut field and pressing the desired key-combination on your keyboard. Click Apply, and that's it!

------------------------------------------------------------------------

**Tips and Tricks**

- To add comments to a function, you can type “Roxygen comment” into the Command Palette (⇧+⌘+P) while the cursor is in a function and it will automatically add a template structure for writing a comment about your function.

  Keyboard shortcut: ⇧⌥⌘R

- Snippets are a way to make a shortcut for inserting text based on a “code”.

  To find the snippets and edit them, use the Palette (`Cmd-Shift-P`) and type “edit snippets”. There you will find some predefined snippets. You can also create your own.

  For instance, when in an R script (or code chunk), typing “fun” followed by pressing `Tab`, a template for a function will be inserted that looks like:

  ```r
  name <- function(variables) {
      
  }
  ```

  You can just fill in the name of the function, then press `Tab` to move to the variables, change the name, then press `Tab` again to move to the function code area and write your function without moving your fingers from the keyboard.

- Show argument definitions as you type functions.

  When you type an existing R function such as `round(`, not only does `tab` give you the options, but there's an explanation beneath each variable, telling you its role in the function:

  <img src="https://i.sstatic.net/tesBV.png" alt="Function Documentation" style="display: block; margin-right: auto; margin-left: auto; zoom:100%;" />



___

