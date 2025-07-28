## VS Code

[`vscode-R`](https://github.com/REditorSupport/vscode-R/wiki) is the R Extension for Visual Studio Code. The extension is mainly focused on providing language service based on static code analysis and user interactivity between VS Code and R sessions.

You can run R in VS Code. Simply open the folder containing your R scripts in VS Code, and then open the command palette (Ctrl+Shift+P) and type "R: Create R terminal". This will start an R session in the terminal.

- By default, this will close the currently open folder. 
- If you want multiple windows each with their own folder, you first open a new window (Ctrl+Shift+N) and then open the folder in that new window.

Q: How to run R code interactively? \
A: Create an R terminal via command **R: Create R Terminal** in the Command Palette. Once an R terminal is ready, you could either select the code or put the cursor at the beginning or ending of the code you want to run, press (<kbd>Ctrl</kbd> + <kbd>Enter</kbd>), and then code will be sent to the active R terminal.
If you want to run an entire R file, open the file in the editor, and press Ctrl+Shift+S and the file will be sourced in the active R terminal.

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


#### Configuration {-}


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

`options(radian.show_vi_mode_prompt = TRUE)`: This option will show the current vi mode in the prompt when using `radian` in vi mode. The prompt will be colored blue and will display the current mode.

- `[ins]`: insert mode
- `[nav]`: normal mode


--------------------------------------------------------------------------------

### FAQ


Q: I cannot see my R Objects in the global environment. \
A: when you click on "**R: (not attached)**" on the bottom bar or type `.vsc.attach()` into the terminal, your objects should start showing up in your global environment.

Q: How to disable `lintr`? \
A: Set `"r.lsp.diagnostics": false`. Then in command palette, type "Developer: Reload Window" for the changes to take effect.

--------------------------------------------------------------------------------


### Plot Viewer {.unnumbered}

[`httpgd`](https://nx10.github.io/httpgd/): A graphics device for R that is accessible via network protocols. This package was created to make it easier to embed live R graphics in integrated development environments and other applications. `httpgd` is required by the interactive plot viewer of the R extension for VS Code.

Enable r.plot.useHttpgd in VS Code settings.

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


--------------------------------------------------------------------------------


### Rmd {.unnumbered}

You can edit Rmd with either of the two Language Mode:

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
    
    Instead, you need to run the `rmarkdown::render()` function in the terminal or in an R script to render the Rmd file.


**Render book**

```r
# Render the site, equivalent to clicking the "Build Book" button in RStudio
# All output formats specified in the `_output.yml` file will be rendered.
rmarkdown::render_site()
# Render a specific output format, e.g., bookdown::gitbook
rmarkdown::render_site(output_format = 'bookdown::gitbook')

# Render the document, equivalent to clicking the "Knit" button in RStudio
# This will apply any global settings for your website and generate the output html in the `docs/` directory.
rmarkdown::render_site("0103-RStudio-VSCode.Rmd")

# Render a single Rmd file
rmarkdown::render("0103-RStudio-VSCode.Rmd")
```


**View book**

To view the static site in the `docs/` directory. I installed the VSCode extension [Live Preview](https://marketplace.visualstudio.com/items?itemName=ms-vscode.live-server). All I need to do is select one of the .html files, right-click the preview button in the code editor, and there it is. I can also just navigate to http://127.0.0.1:3000/docs/ in my browser. It even updates as I add chapters and redo the `render_site()` command.



References:

- [R in Visual Studio Code](https://code.visualstudio.com/docs/languages/r)
- Settings for `vscode-R`: 
  - <https://renkun.me/2019/12/26/writing-r-in-vscode-interacting-with-an-r-session/>
  - <https://francojc.github.io/posts/r-in-vscode/>
- Getting started with `httpgd`: <https://nx10.github.io/httpgd/articles/getting-started.html>
- Bookdown in VS code: <https://www.bendirt.com/bookdown/>
