## Theorems

<https://stackoverflow.com/questions/50379923/bookdown-remark-environment>

Language internationalization: <https://bookdown.org/yihui/bookdown/internationalization.html>



Theorem environments in the [`bookdown` package](https://bookdown.org/yihui/bookdown/markdown-extensions-by-bookdown.html#tab:theorem-envs).

<a id="thm-env-names">Table: Theorem environments in **bookdown**.</a>

| Environment   | Printed Name | Label Prefix |
| :------------- | :------------ | :------------ |
| `theorem`     | Theorem      | thm          |
| `lemma`       | Lemma        | lem          |
| `corollary`   | Corollary    | cor          |
| `proposition` | Proposition  | prp          |
| `conjecture`  | Conjecture   | cnj          |
| `definition`  | Definition   | def          |
| `example`     | Example      | exm          |
| `exercise`    | Exercise     | exr          |
| `hypothesis`  | Hypothesis   | hyp          |

- Definition 定义: an explanation of the mathematical meaning of a word.

- Theorem 定理: A statement that has been proven to be true.

  是文章中重要的数学化的论述，一般有严格的数学证明。

- Proposition 命题: A less important but nonetheless interesting true statement.

  经过证明且 intersting，但没有 Theorem 重要，比较常用。

- Lemma 引理: A true statement used in proving other true statements (that is, a less important theorem that is helpful in the proof of other results). 
  
  帮助证明 Theorem 的小结果。有时候可以将 Theorem 拆分成多个小的 Lemma 来逐步证明，以使得证明的思路更加清晰。很少情况下 Lemma 会以其自身的形式存在。
  
  - Lemmas are considered to be less important than propositions. But the distinction between categories is rather *blurred*. 
  - There is no formal distinction among a lemma, a proposition, and a theorem.
  
- Corollary 推论: A true statment that is a simple deduction from a Theorem or Proposition.

- Proof: The explanation of why a statement is true.

- Conjecture 猜想，猜测: A statement believed to be true, but for which we have no proof. (a statement that is being proposed to be a true statement).

- Axiom 公理: A basic assumption about a mathematical situation. (a statement we assume to be true).

  不需要证明的论述，是其他所有 Theorem 的基础。


--------------------------------------------------------------------------------

**Usage**

**Theorems and proofs** provide environments that are commonly used within articles and books in mathematics. To write a theorem, you can use the syntax below:

~~~markdown
```{theorem, label, name="Theorem name"}
Here is my first theorem.
```
~~~

will be rendered as:

::: {.theorem #label name="Theorem name"}
Here is my first theorem.
:::

Refer to the theorem using `\@ref(prefix:label)`. 
See the column `Label Prefix` in <a href="#thm-env-names">Table</a> for the value of `prefix` for each environment. 
E.g., see theorem \@ref(thm:label) (`\@ref(thm:label)`).

If you want to refer to a theorem, you should **label** it. The label can be provided as an ID to the block of the form `#label`.


--------------------------------------------------------------------------------

Another example

~~~markdown
```{theorem, thm-py, name="Pythagorean theorem"}
For a right triangle, if $c$ denotes the length of the hypotenuse and $a$ and $b$ denote the lengths of the other two sides, we have
  
  \begin{align*}
  c^2 = a^2+b^2
  \end{align*}
```
~~~

will be rendered as:

::: {.theorem #thm-py name="Pythagorean theorem"}
For a right triangle, if $c$ denotes the length of the hypotenuse and $a$ and $b$ denote the lengths of the other two sides, we have
  
  \begin{align*}
  c^2 = a^2+b^2
  \end{align*}
:::

--------------------------------------------------------------------------------

Alternatively, you can use the syntax based on Pandoc’s [fenced `Div` blocks](https://pandoc.org/MANUAL.html#divs-and-spans). It can already be used in any R Markdown document to write [custom blocks.](https://bookdown.org/yihui/rmarkdown-cookbook/custom-blocks.html)

```markdown
::: {.theorem #pyth name="Pythagorean theorem"}
For a right triangle, if $c$ denotes the length of the hypotenuse
and $a$ and $b$ denote the lengths of the other two sides, we have

$$a^2 + b^2 = c^2$$
:::
```


::: {.theorem #pyth name="Pythagorean theorem"}
For a right triangle, if $c$ denotes the length of the hypotenuse
and $a$ and $b$ denote the lengths of the other two sides, we have

$$a^2 + b^2 = c^2$$
:::

Apply Theorem \@ref(thm:pyth), ...

--------------------------------------------------------------------------------

- Variants of the `theorem` environments include: `lemma`, `corollary`, `proposition`, `conjecture`, `definition`, `example`, and `exercise`. The syntax for these environments is similar to the `theorem` environment, e.g., ````{lemma}`.

- The `proof` environment behaves similarly to theorem environments but is unnumbered. Variants of the `proof` environments include `remark` and `solution`. 

  The `proof`environment behaves similarly to theorem environments but is unnumbered.

--------------------------------------------------------------------------------

**Customize math environment labels**

You need to create a file `_bookdown.yml` in the same directory as your `.Rmd`. 

In the configuration file **`_bookdown.yml`**

For example, if you want `FIGURE x.x` instead of `Figure x.x`, you can change `fig` to `"FIGURE "`:

```yaml
language:
  label:
    fig: "FIGURE "
```

If you want to number `proof`, 

1. choose one of the [predefined theorem like environments](https://bookdown.org/yihui/bookdown/markdown-extensions-by-bookdown.html#theorems) that you are not using otherwise, e.g. `example` or `exercise`.

2. Redefine the printed name for that environment in `_bookdown.yml` (c.f. https://bookdown.org/yihui/bookdown/internationalization.html) via:

   ```r
   language:
     label:
       exr: 'Proof '
   ```

   Here I changed the `exercise` environment leading word to "Proof ".

3. In your `Rmd` files use `{exercise, mylabel}` environment. 

   ~~~latex
   ```{exercise, mylabel}
   my comment
   ```
   
   In Remark \@ref(exr:mylabel) we discussed...
   ~~~

   Note that you have to use `exercise` and the corresponding label prefix `exr`.

--------------------------------------------------------------------------------

Can specify environment style in `style.css`

```css
.exercise {
    margin: 10px 5px 20px 5px; 
}
/* define a boxed environment */
.boxed {
    border: 1px solid #535353;
    padding-bottom: 20px;
}
```



````latex
<div class = "boxed">
```{exercise, proof2}
Show $\pi=\Phi \left(\frac{\mu}{\sigma}\right)$.
$$
\begin{aligned}[b]
P(r_t>0) &= P(\mu+e_t>0) \\
&= P(e_t>-\mu) \quad\quad\quad (\sigma>0, \text{dividing by a pos. number, inequality unchanged}) \\
&= P\left( \frac{e_t}{\sigma} > -\frac{\mu}{\sigma}\right) \quad\;\; e_t\sim N(0, \sigma^2), \text{ then } \frac{e_t}{\sigma}\sim N(0,1) \\
&= P \left( \frac{e_t}{\sigma} < \frac{\mu}{\sigma} \right) \\
&= \Phi \left(\frac{\mu}{\sigma} \right) 
\end{aligned}  \square
$$
```
</div>
````

<img src="https://drive.google.com/thumbnail?id=1bqVq_6WTId8Svf7hihPoqJ-ouZTSOIWL&sz=w1000" alt="box_theorem" style="display: block; margin-right: auto; margin-left: auto; zoom:80%;" />
