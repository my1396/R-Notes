## Theorems

<https://stackoverflow.com/questions/50379923/bookdown-remark-environment>

Language internationalization: <https://bookdown.org/yihui/bookdown/internationalization.html>



Theorem environments in the [`bookdown` package](https://bookdown.org/yihui/bookdown/markdown-extensions-by-bookdown.html#tab:theorem-envs).

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

- Definition : an explanation of the mathematical meaning of a word.
- Theorem : A statement that has been proven to be true.
- Proposition : A less important but nonetheless interesting true statement.
- Lemma: A true statement used in proving other true statements (that is, a less important theorem that is helpful in the proof of other results). 
  - Lemmas are considered to be less important than propositions. But the distinction between categories is rather *blurred*. 
  - There is no formal distinction among a lemma, a proposition, and a theorem.
- Corollary: A true statment that is a simple deduction from a theorem or proposition.
- Proof: The explanation of why a statement is true.
- Conjecture: A statement believed to be true, but for which we have no proof. (a statement that is being proposed to be a true statement).
- Axiom: A basic assumption about a mathematical situation. (a statement we assume to be true).


--------------------------------------------------------------------------------

**Usage**

**Theorems and proofs** provide environments that are commonly used within articles and books in mathematics. To write a theorem, you can use the syntax below:

~~~markdown
```{theorem, label, name="Theorem name"}
Here is my first theorem.
```
~~~

will be rendered as:

\BeginKnitrBlock{theorem}\iffalse{-91-84-104-101-111-114-101-109-32-110-97-109-101-93-}\fi{}<div class="theorem"><span class="theorem" id="thm:label"><strong>(\#thm:label)  \iffalse (Theorem name) \fi{} </strong></span>Here is my first theorem.</div>\EndKnitrBlock{theorem}

Refer to the theorem using `\@ref(thm:label)`, e.g., see theorem \@ref(thm:label).


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

\BeginKnitrBlock{theorem}\iffalse{-91-80-121-116-104-97-103-111-114-101-97-110-32-116-104-101-111-114-101-109-93-}\fi{}<div class="theorem"><span class="theorem" id="thm:thm-py"><strong>(\#thm:thm-py)  \iffalse (Pythagorean theorem) \fi{} </strong></span>For a right triangle, if $c$ denotes the length of the hypotenuse and $a$ and $b$ denote the lengths of the other two sides, we have
  
  \begin{align*}
  c^2 = a^2+b^2
  \end{align*}</div>\EndKnitrBlock{theorem}


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
