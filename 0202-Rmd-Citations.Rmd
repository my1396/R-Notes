## Citing References

Use `@citationkey` to cite references in text.

Put citations in parentheses, use `[@citationkey]`.

To cite multiple entries, separate the keys by semicolons, e.g., `[@key-1; @key-2; @key-3]`. To suppress the mention of the author, add a minus sign before `@`, e.g., `[-@citationkey]`.

| Syntax                                                       | Result                                                       |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `@adams1975` concludes that …                                | Adams (1975) concludes that …                                |
| `@adams1975[p.33]` concludes that …                          | Adams (1975, p. 33) concludes that …                         |
| … end of sentence `[@adams1975]`.                            | … end of sentence (Adams, 1975).                             |
| `[see @adams1975,p.33]`.                                     | … end of sentence (see Adams, 1975, p. 33).                  |
| delineate multiple authors with colon: `[@adams1975; @aberdeen1958]` | delineate multiple authors with colon: (Aberdeen, 1958; Adams, 1975) |
| Check Lo and MacKinlay `[-@Lo-Mackinlay1988; -@Lo1989]` for example. | Check Lo and MacKinlay (1988, 1989) for example.             |

**Add an item to a bibliography without using it**

By default, the bibliography will only display items that are directly referenced in the document. 

If you want to include items in the bibliography without actually citing them in the body text, you can define a dummy `nocite` metadata field and put the citations there.

```markdown
---
nocite: |
  @item1, @item2
---
```

