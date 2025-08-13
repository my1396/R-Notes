## VS Code

[`vscode-R`](https://github.com/REditorSupport/vscode-R/wiki) is the R Extension for Visual Studio Code. The extension is mainly focused on providing language service based on static code analysis and user interactivity between VS Code and R sessions.

You can run R in VS Code. Simply open the folder containing your R scripts in VS Code, and then open the command palette (`Cmd+Shift+P`) and type "R: Create R terminal". This will start an R session in the terminal.

- By default, this will close the currently open folder. 
- If you want multiple windows each with their own folder, you first open a new window (`Ctrl` + `Shift` + `N`) and then open the folder in that new window.

`rstudioapi::restartSession()` will restart the R session.

Command Palette, type "**R: Interrupt R**" to interrupt the current R session.


#### Keyboard shortcuts

|                    Shortcuts                     |      Function       |
| :----------------------------------------------: | :-----------------: |
|                  `cmd`   + `/`                   |       comment       |
| `shift` + `cmd`  + `M`<br>`shift` + `ctrl` + `M` | user defined; `%>%` |
|                  `opt`   + `-`                   | user defined; `<-`  |

- For commonly used general keyboard shortcuts (not limited to R), see [HERE](https://my1396.github.io/Econ-Study/2024/08/12/Productivity-Tools.html#keyboard-shortcuts).

- [Suggested keyboard shortcuts](https://github.com/REditorSupport/vscode-R/wiki/Keyboard-shortcuts) for R in VS Code.

- For user defined shortcuts, you can add them in the `keybindings.json` file.


--------------------------------------------------------------------------------

Q: How to run R code interactively? \
A: Create an R terminal via command **R: Create R Terminal** in the Command Palette. Once an R terminal is ready, you could either select the code or put the cursor at the beginning or ending of the code you want to run, press (<kbd>Ctrl</kbd> + <kbd>Enter</kbd>), and then code will be sent to the active R terminal. 

If you want to run an entire R file, open the file in the editor, and press <kbd>Ctrl+Shift+S</kbd> and the file will be sourced in the active R terminal.

--------------------------------------------------------------------------------

Q: Why use VS Code for R programming instead of RStudio? \
A: Several reasons:

- Better integration with Copilot, making it easier to write code with AI assistance. 
- More responsive and powerful engineering tools such as symbol highlight, find references, rename symbol, etc. integrated to the IDE.
- VS Code has a lot of extensions that can enhance your R programming experience, such as `Markdown Preview Enhance`, `Live Server`, and `GitLens`.
- Git support is better in VS Code, making it easier for version control and collaboration.

--------------------------------------------------------------------------------

### `languageserver` package

The [R language server](https://github.com/REditorSupport/vscode-R/wiki/R-Language-Service) implements the [Language Server Protocol](https://microsoft.github.io/language-server-protocol/specifications/specification-current/) (LSP) and provides a set of language analysis features such as *completion*, providing function signatures, extended function documentation, locating function implementations, occurrences of a symbol or object, *rename symbol*, and code diagnostics and formatting. The R language server statically analyzes R code, and `vscode-R` interfaces with it to provide the core of this extension's functionality.

The R language server is implemented by the [languageserver](https://github.com/REditorSupport/languageserver) package which performs static code analysis with the latest user documents in `R` and `Rmd` languages. Therefore, it does not rely on an active R session and thus does not require the code to be executed.

[vscode-R settings](https://github.com/REditorSupport/vscode-R/wiki/R-options)

#### Highlight Features:

- `styler`

  The language server provides code formatting through the through the [`styler`](https://github.com/r-lib/styler) package in R. See [here](https://github.com/REditorSupport/languageserver#customizing-formatting-style) for configuration.

  Main usage: select the code block you want to format, right-click and select **Format Selection**. Note that this only works in the **Edit Mode** when Vim is enabled.

  Alternatively, right-click at anywhere in the code editor and select **Format Document** to format the entire document. 

- **Rename symbols** 

  Place the cursor on the symbol you want to rename, right-click and select **Rename Symbol**. A dialog will pop up, allowing you to enter the new name for the symbol. A refactoring preview will be shown, allowing you to review the changes before applying them.

- **Find References**
  
  Right-click on an R object, 
  - select **Find All References** to find all references to the object in the current workspace.
    
    The results will be shown in the **References** view in the Activity Bar on the left side of the window.

  - select *Go To References* open a popup showing all of the uses of the object within the current document.

--------------------------------------------------------------------------------

#### `lintr`

R code linting (diagnostics) is provided by [lintr](https://github.com/r-lib/lintr) via language server and is enabled by default. It provides syntax error warnings as well as style guidelines.

**Configuration**

To configure the behavior of `lintr`, you should create/edit the global `lintr` config file at `~/.lintr`. Alternatively, you can also create/edit a project-specific lintr config file at `${workspaceFolder}/.lintr`. 

- Do not forget the new **empty line** at the end of the file.

  To be sure that the file is correctly set up you can use:

  ```r
  read.dcf(".lintr") # Should give no error
  ```

  If the file is not available in the workspace you can add it with:

  ```r
  options(lintr.linter_file="Path/to/file/.lintr")
  ```

  You can also add this line in your `.Rprofile` to not have to run it everytime. [ref ↩︎](︎https://stackoverflow.com/a/77286956)

- Visit [Individual linters](https://lintr.r-lib.org/reference/index.html#individual-linters) for a complete list of supported linters.

- Visit the [Configuring linters](https://lintr.r-lib.org/articles/lintr.html#configuring-linters) for a complete guide to customizing lintr config regarding the list of linters and file or line exclusions.



Q: How to disable `lintr`? \
A: Set `"r.lsp.diagnostics": false`. Then in command palette, type "Developer: Reload Window" for the changes to take effect.



--------------------------------------------------------------------------------

### Radian

Q: There is no syntax highlighting in the R terminal. How to fix it? \
A: Install [**Radian**](https://github.com/randy3k/radian), an improved **R console** REPL interface that corrects many limitations of the official R terminal and supports many features such as *syntax highlighting* and *auto-completion*. In the terminal, run

```bash
$pipx install radian
  installed package radian 0.6.15, installed using Python 3.13.5
  These apps are now globally available
    - radian
⚠️  Note: '/Users/menghan/.local/bin' is not on your PATH environment variable. These apps will not be globally
    accessible until your PATH is updated. Run `pipx ensurepath` to automatically add it, or manually modify your PATH in
    your shell's config file (e.g. ~/.bashrc).
done! ✨ 🌟 ✨

$pipx ensurepath

/Users/menghan/.local/bin has been been added to PATH, but you need to open a new terminal or re-login for this PATH
    change to take effect. Alternatively, you can source your shell's config file with e.g. 'source ~/.bashrc'.

You will need to open a new terminal or re-login for the PATH changes to take effect. Alternatively, you can source your
shell's config file with e.g. 'source ~/.bashrc'.
```

N.B. If you have `zsh` as your shell, you need to run `source ~/.zshrc` instead of `source ~/.bashrc`.

To find where `radian` is installed, you can run:

```bash
which radian
/Users/menghan/.local/bin/radian
```

This is the path to the `radian` executable.

After adding Radian to your PATH, you can invoke it in the terminal by simply typing `radian`.

```bash
$radian
R version 4.3.1 (2023-06-16) -- "Beagle Scouts"
Platform: aarch64-apple-darwin20 (64-bit)

r$>
```

Then, in VS Code, you will need to set Radian as the default R terminal. You can also configure other settings for R.

```json
{
  "r.rterm.mac": "/Users/menghan/.local/bin/radian",
  "r.bracketedPaste": true,
  "r.sessionWatcher": true,
}
```

- `r.rterm.mac`: Path to the Radian executable.
- `r.bracketedPaste`: Enables bracketed paste mode, which allows pasting code without executing it immediately. This is useful if you want to paste multiple lines of code into the console at once.
- `r.sessionWatcher`: Enables [session watcher](https://github-wiki-see.page/m/REditorSupport/vscode-R/wiki/R-Session-watcher) to monitor the R session. Specifically, 
  
    - Show value of session symbols on hover
    - Show plot output on update and plot history
    - Show htmlwidgets, documentation and shiny apps in WebView

- `r.alwaysUseActiveTerminal`: always send code to active terminal rather than `vscode-R`; helps me to start an R session which is terminated when VSCode exits.

- `r.plot.useHttpgd`: Use the httpgd package for viewing plots in a VS Code window or in the browser.

See [Extension Settings](https://github.com/REditorSupport/vscode-R/wiki/Extension-settings) for a full list of settings of `vscode-R` that can be set in VSCode's `settings.json` file.


#### Configuration


radian can be customized by specifying the below options in various locations:

- `$HOME/.config/radian/profile`
- `.radian_profile` in the working directory


Example of a radian [profile](https://github.com/randy3k/radian?tab=readme-ov-file#settings)

```r
# either  `"emacs"` (default) or `"vi"`.
options(radian.editing_mode = "vi")

# enable various emacs bindings in vi insert mode
options(radian.emacs_bindings_in_vi_insert_mode = TRUE)

# show vi mode state when radian.editing_mode is `vi`
options(radian.show_vi_mode_prompt = TRUE)
options(radian.vi_mode_prompt = "\033[0;34m[{}]\033[0m ")

# custom key bindings
options(
    radian.escape_key_map = list(
        list(key = "-", value = " <- "),
    ),
    radian.ctrl_key_map = list(
        list(key = "right", value = " %>% ")
    )
)
```

**VI support by `radian`:**

- `options(radian.editing_mode = "vi")`: set the default editing mode to vi. 
- `options(radian.show_vi_mode_prompt = TRUE)`: This option will show the current vi mode in the prompt when using `radian` in vi mode. The prompt will be colored blue and will display the current mode.

  - `[ins]`: insert mode
  - `[nav]`: normal mode


--------------------------------------------------------------------------------

### FAQ


Q: I cannot see my R Objects in the global environment. \
A: when you click on "**R: (not attached)**" on the bottom bar or type `.vsc.attach()` into the terminal, your objects should start showing up in your global environment.

Q: How to hide variables in **OUTLINE view**? \
A: OUTLINE view by default shows all variables in the current R script, making it difficult to locate your true sections. To hide variables, go to command palette, type "Outline: Show", there is a list of objects that you can choose to show or hide (you can choose to set this for workspace or the user). Here is my current setting:

```json
{
  "outline.showArrays": false,
  "outline.showBooleans": false,
  "outline.showClasses": true,
  "outline.showConstants": false,
  "outline.showFields": false // this hides most variables you actually don't want to see
}
```

> **Note** that some answers mention that you should use `"outline.showVariables": false`, but this does NOT work for me. Instead, I use `"outline.showFields": false` to hide most variables.

See [HERE](https://code.visualstudio.com/docs/editing/intellisense#_types-of-completions) for a complete list of icons and their meanings in the OUTLINE view. 

The following tables shows the icons that you most commonly see in the OUTLINE view.


<table class="table table-striped">
  <thead>
    <tr>
      <th>Icon</th>
      <th>Name</th>
      <th>Symbol type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><i class="codicon codicon-symbol-method" style="font-size: 1.2em;color:#b180d7"></i></td>
      <td>Methods and Functions</td>
      <td><code>method</code>, <code>function</code>, <code>constructor</code></td>
    </tr>
    <tr>
      <td><i class="codicon codicon-symbol-variable" style="font-size: 1.2em;color:#75beff"></i></td>
      <td>Variables</td>
      <td><code>variable</code></td>
    </tr>
    <tr>
      <td><i class="codicon codicon-symbol-field" style="font-size: 1.2em;color:#75beff"></i></td>
      <td>Fields</td>
      <td><code>field</code></td>
    </tr>
    <tr>
      <td><i class="codicon codicon-symbol-text" style="font-size: 1.2em;"></i></td>
      <td>Words</td>
      <td><code>text</code></td>
    </tr>
    <tr>
      <td><i class="codicon codicon-symbol-constant" style="font-size: 1.2em;"></i></td>
      <td>Constants</td>
      <td><code>constant</code></td>
    </tr>
    <tr>
      <td><i class="codicon codicon-symbol-class" style="font-size: 1.2em;color:#ee9d28"></i></td>
      <td>Classes</td>
      <td><code>class</code></td>
    </tr>
    <tr>
      <td><i class="codicon codicon-symbol-structure" style="font-size: 1.2em;"></i></td>
      <td>Structures</td>
      <td><code>struct</code></td>
    </tr>
    <tr>
      <td><i class="codicon codicon-symbol-namespace" style="font-size: 1.2em;"></i></td>
      <td>Modules</td>
      <td><code>module</code></td>
    </tr>
    <tr>
      <td><i class="codicon codicon-symbol-property" style="font-size: 1.2em;"></i></td>
      <td>Properties and Attributes</td>
      <td><code>property</code></td>
    </tr>
  </tbody>
</table>

- Constant <i class="codicon codicon-symbol-constant" style="font-size: 1.2em;vertical-align: middle;"></i> applies to Quarto sections. Need to set `"outline.showConstants": true,` to show sections properly in the OUTLINE view.

--------------------------------------------------------------------------------


### Plot Viewer

[`httpgd`](https://nx10.github.io/httpgd/): A graphics device for R that is accessible via network protocols. This package was created to make it easier to embed live R graphics in integrated development environments and other applications. `httpgd` is required by the interactive plot viewer of the R extension for VS Code.

Enable `r.plot.useHttpgd` in VS Code settings.

```json
{
  "r.plot.useHttpgd": true
}
```
- `r.plot.useHttpgd`: use the httpgd-based plot viewer instead of the base VSCode-R plot viewer

This will allow you to view plots in a separate window or in the browser, which is useful for interactive visualizations.

The `httpgd` plot viewer supports auto-resizing, light/dark theme mode, plot history, hiding and zooming.

<img src="https://drive.google.com/thumbnail?id=1vMoXU2U1SCsjgpK750ri_TPUMvWJjoM8&sz=w1000" alt="" style="display: block; margin-right: auto; margin-left: auto; zoom:80%;" />

Getting started with `httpgd`

```r
library(httpgd)
# Start the httpgd graphics device
hgd()

# Open the plot viewer in your browser
hgd_browse()

# Create a figure
x = seq(0, 3 * pi, by = 0.1)
plot(x, sin(x), type = "l")

# Close the graphics device
dev.off()
```

Q: Plot viewer is missing. \
A: Run `hgd()` in R and get the url to the viewer. Use the command palette to run "**R Plot: Open httpgd Url**". It will let you enter the url address, fill it in and hit Enter to open the plot viewer. Alternatively, if you want to view in external browser, you can copy the url and paste it in your browser.


- `hgd` Initialize device and start server.
- `hgd_browse` Open the plot viewer in your browser.

Universal graphics device (`unigd`) is a package that provides a set of functions to manage the plot viewer, such as:

- `unigd::ugd_clear()` Clear all pages in the plot viewer.
- `unigd::ugd_remove(page = 2)` Remove the second page

Ref:

- [Using httpgd in VSCode: A web-based SVG graphics device, \@Kun Ren](https://renkun.me/2020/06/16/using-httpgd-in-vscode-a-web-based-svg-graphics-device/)

--------------------------------------------------------------------------------

### R Debugger

To be added ...

ref: 

- [Debugging R in VSCode, \@Kun Ren](https://renkun.me/2020/09/13/debugging-r-in-vscode/)



--------------------------------------------------------------------------------

### Emulating `rstudioapi` functions 

The VSCode-R extension is compatible with a subset of RStudio Addins via an `{rstudioapi}` emulation layer. Nearly all of the document inspection and manipulation API is supported, allowing RStudio add-ins and packages that rely on `rstudioapi` to function within VS Code.

-   This emulation is achieved by "duck punching" or "monkey patching" the `rstudioapi` functions within the R session running in VS Code. This means the original `rstudioapi` functions are replaced with custom implementations that communicate with VS Code instead of RStudio.

-   To enable RStudio Addins, you may need to add `options(vsc.rstudioapi = TRUE)` to your `~/.Rprofile` file. This ensures the `rstudioapi` emulation is loaded when your R session starts.

    `getOption("vsc.rstudioapi")` will return `TRUE` if the emulation is enabled.

--------------------------------------------------------------------------------

**Use RStudio Addins from VS Code** 

How to use your RStudio Addins in VS Code after enabling the emulation:

-  Use the command palette (`Ctrl+Shift+P`) and type "**R: Launch RStudio Addin**".
-  You will see a list of available RStudio add-ins that you can run directly from VS Code. 
-  Choose the add-in you want to run, and it will execute in the current R session.

--------------------------------------------------------------------------------

You can also bind a keyboard shortcut to **launch the RStudio Addin picker** (command id: `r.launchAddinPicker`):

```json
{
	"key": "ctrl+shift+A",  // launch RStudio Addin
	"command": "r.launchAddinPicker",
	"when": "editorTextFocus && (editorLangId == 'markdown' || editorLangId == 'r' || editorLangId == 'rmd' || editorLangId == 'quarto')"
},
```

This will allow you to quickly access and run RStudio add-ins without needing to open the command palette each time.

--------------------------------------------------------------------------------

To **launch a specific RStudio addin**, you can map a direct keybinding to the addin R functions. 

- The function can be found in `inst/rstudion/addins.dcf` file of the addin-providing-package's source. 
  - Look for the keyword `Binding` in the file to find the function name.
  - The package name is the repository name of the addin-providing package.

Use example: Here I want to invoke two RStudio addins: `shoRtcut::set_new_chapter()` and `shoRtcut2::set_new_chapter2()`. 

Add the following keybindings to your `keybindings.json` file:

```json
{
  "description": "Pad line with dashes",
  "key": "ctrl+shift+S",
  "command": "r.runCommand",
  "when": "editorTextFocus && (editorLangId == 'markdown' || editorLangId == 'r' || editorLangId == 'rmd' || editorLangId == 'quarto')",
  "args": "shoRtcut:::set_new_chapter()"
},
{
  "description": "Pad line with equals",
  "key": "ctrl+shift+=",
  "command": "r.runCommand",
  "when": "editorTextFocus && (editorLangId == 'markdown' || editorLangId == 'r' || editorLangId == 'rmd' || editorLangId == 'quarto')",
  "args": "shoRtcut2:::set_new_chapter2()"
},
```

Now you can use

- `Ctrl+Shift+S` to pad a line with dashes, and 
- `Ctrl+Shift+=` to pad a line with equals.

ref: [RStudio addin support in VSCode-R](https://github.com/REditorSupport/vscode-R/wiki/RStudio-addin-support)

--------------------------------------------------------------------------------

### Work with Rmd

You can edit Rmd with either of the two Language Modes:

- `R Markdown`: there is a knit button to provide preview but no live preview.
  
    If using RStudio, you can only get a preview after rendering 

    - Render the site using: `rmarkdown::render_site()` function, which can be slow for large sites. 
    - Render the document using: `rmarkdown::render("0103-RStudio-VSCode.Rmd")` function, which is equivalent to clicking the "Knit" button in RStudio.

    Note that 

    - Knit button generate output html in the `docs/` directory; it uses your styles settings in the `_output.yml` file.
    - `rmarkdown::render` generates output html in the same directory as the Rmd file. It does not apply any settings from `_output.yml` file, so you need to specify any headers you want to load, e.g., mathjax macros.
    
    
    How to decide which Language Mode to use? A rule of thumb is:

    - If your Rmd has lots of R code you need to run interactively, use `R Markdown`.
    - If you want to write a static report with minimal R code, use `Markdown`.
    
      At all cases, it is quite easy to switch between the two modes by changing the Language Mode in the bottom right corner of VS Code. So you can choose either one that suits you best.
  
- `Markdown`: there is no knit button but you can have a live preview using the `Markdown Preview Enhance` extension.
  
    Instead, you need to type the command `rmarkdown::render()` in the R console or in an R script to render the Rmd file.


#### Render book

Render the site `rmarkdown::render_site(input = ".", output_format = "all")`

- `rmarkdown::render_site()` without arguments will render **all** formats by default.
- specify `output_format` to render a specific format, e.g., `bookdown::gitbook`, `bookdown::pdf_book`, etc.

```r
# Render the site, equivalent to clicking the "Build Book" button in RStudio
# All output formats specified in the `_output.yml` file will be rendered.
rmarkdown::render_site()
# Render a specific output format, e.g., bookdown::gitbook
rmarkdown::render_site(output_format = 'bookdown::gitbook')
```

Render a single document has two options:

- `rmarkdown::render_site(file_name)` looks for the `_output.yml` file in the root directory of the site and applies the settings specified in that file. See [HERE](#render-single-rmd) for more details.
  
  Recommended for its automatic formatting. ✅

- `rmarkdown::render(input, output_format = NULL)` renders any single Rmd file without applying any settings from `_output.yml` file. See [HERE](#render-rmd-site) for more details.
  
  You need to specify any headers you want to load, e.g., mathjax macros. More hassle → less recommended. 

```r
# Render the document, equivalent to clicking the "Knit" button in RStudio
# This will apply any global settings for your website and generate the output html in the `docs/` directory.
rmarkdown::render_site("0103-RStudio-VSCode.Rmd")

# Render a single Rmd file
rmarkdown::render("0103-RStudio-VSCode.Rmd")
```



#### View book

To view the static site in the `docs/` directory. I installed the VSCode extension [Live Preview](https://marketplace.visualstudio.com/items?itemName=ms-vscode.live-server). All I need to do is select one of the .html files, right-click the preview button in the code editor, and there it is. I can also just navigate to http://127.0.0.1:3000/docs/ in my browser. It even updates as I add chapters and redo the `render_site()` command.

- If Live Preview is not loading the latest changes, try "**Developer: Reload Window**" in the command palette.
- A most reliable way is just to open the `docs/xxx.html` file in your browser. This way, not only will it open the file you clicked, but it will also open the entire site.
  
  An additional benefit is that your site won't blink when you make changes or build the site. I found the constant blinking of the Live Preview blinding. 
  
  Using static files, you simply refresh the browser every time you rebuild the site.


### Extensions

[`R Tools`](https://marketplace.visualstudio.com/items?itemName=Mikhail-Arkhipov.r) provides support for the R language, including syntax checking, completions, code formatting, formatting as you type, tooltips, linting.

Open the Command Palette and type '**R:**' to see list of available commands and shortcuts.

ref

- [vscode-R Wiki: R Markdown](https://github.com/REditorSupport/vscode-R/wiki/R-Markdown)

--------------------------------------------------------------------------------


**References**:

- [R in Visual Studio Code](https://code.visualstudio.com/docs/languages/r)
- Set up `vscode-R`: 
  - <https://renkun.me/2019/12/26/writing-r-in-vscode-interacting-with-an-r-session/>
  - <https://francojc.github.io/posts/r-in-vscode/>
  - [VS Code for R on macOS](https://jimgar.github.io/posts/vs-code-macos-r/post.html#extensions)
- Getting started with `httpgd`: <https://nx10.github.io/httpgd/articles/getting-started.html>
- Bookdown in VS code: <https://www.bendirt.com/bookdown/>
