## Toggle Visibility of Solutions

When the bookdown file loads, you would like all the solutions to be hidden. You would like a button for each solution to toggle its visibility. 

Easy solution: this works but cannot show math equations properly. ❌

- Advantage is that it does not need to define any java function.

```html
<button class="button" onclick="$('#target2').toggle();">
    Show/Hide
</button>
<div id="target2" style="display: none">
    Solution:
    $P(\textrm{A wins or B wins}) = P\big(\{\textrm{A wins}\} \cup \{\textrm{B wins}\}\big)$
</div>
```

Example: 

<button class="button" onclick="$('#target2').toggle();">
    Show/Hide
</button>
<div id="target2" style="display: none">
    Solution:
    $P(\textrm{A wins or B wins}) = P\big(\{\textrm{A wins}\} \cup \{\textrm{B wins}\}\big)$
</div>

<br>

--------------------------------------------------------------------------------

<span style='color:#00CC66; font-size:21px'>**Ultimate solution!** </span>

Able to show math equations properly ✅

1. Put the following codes in the Rmd <span style='color:#00CC66'>header</span>. This defines the button action `myFunction`. 

    ```html
    <script> 
        function myFunction(id) {
          var x = document.getElementById(id); 
          if (x.style.display === "none") {
            x.style.display = "block";
          } else {
            x.style.display = "none";
          }
        }
    </script>
    ```
    
    In case of `bookdown`, put the JavaScript in `script.hhml`, which will be loaded into the header of all your html files via `_output.yml`.
    
    ```yml
    bookdown::gitbook:
      css: assets/styling/style.css
      includes:
        in_header: assets/styling/head.html
        after_body: assets/styling/scripts.html
      # ...
    ```
    

2. When you want to create a solution division, use the following codes. 
   - Change the <span style='color:#00CC66'>function argument `myDIV`</span>, which is the `id` of the element. `id` must be unique in one file.
   - Change the text shown on the button (`Solution1`) if you need.
   - Put your solution inside the `<div id=myDIV>` tag, where `id` is what you specified in the function argument.

````html
```{example, ex1}
Let $Y=g(X)=\mu+\sigma X$ where $\sigma>0$. Representing the CDF of $Y$ using $F_X(x)$.
```

<button onclick="myFunction('myDIV')">Solution1</button>

<div id="myDIV" style="display: none; color: blue;">
  $P(\textrm{A wins or B wins}) = P\big(\{\textrm{A wins}\} \cup \{\textrm{B wins}\}\big)$
  solution1
</div>

```{example, ex2}
Let $X\sim N(0,1)$ and $Y=\mu+\sigma X$. Calculate $\mathbb{E}(Y)$.
```

<button onclick="myFunction('myDIV2')">Solution2</button>
<div id="myDIV2" style="display: none; color: blue;">
  $P(\textrm{A wins or B wins}) = P\big(\{\textrm{A wins}\} \cup \{\textrm{B wins}\}\big)$
  solution2 
</div>

blabla ...
blabla ...
````

\BeginKnitrBlock{example}<div class="example"><span class="example" id="exm:ex1"><strong>(\#exm:ex1) </strong></span>Let $Y=g(X)=\mu+\sigma X$ where $\sigma>0$. Representing the CDF of $Y$ using $F_X(x)$.</div>\EndKnitrBlock{example}

<button onclick="myFunction('myDIV')">Solution</button>

<div id="myDIV" style="display: none; color: blue;">
Note that $g(x)$ is strictly increasing in $x$.
The inverse function is
$$
X = g^{-1}(Y) = \frac{Y-\mu}{\sigma}
$$
and so
$$
F_Y(y) = F_X\left(g^{-1}(y)\right) = F_X\left(\frac{y-\mu}{\sigma}\right)
$$
</div>

 

--------------------------------------------------------------------------------

**References**:

- <https://stackoverflow.com/questions/62549757/toggle-show-hide-element-where-default-on-refresh-is-hide>
- <https://naras.su.domains/post/toggle-visibility-of-solutions-in-bookdown/>










