## Matrix multiplication

**Dot product** (element to element multiplication, then sum the result) `sum(x*y)` 

**Matrix product or inner product** of vectors `X %*% Y` is $X^TY$.

- `crossprod(x, y)` is equivalent to `t(x) %*% y`, or
- `tcrossprod(x, y)` same as `x %*% t(y)`.

Vector **outer product** `%o%` or `outer(X, Y, FUN = "*")` outer product is $XY^T$, can be calculated as `as.vector(X) %*% t(as.vector(Y))`

`outer(x, y, FUN = "*")` `FUN` can be other operations, such as `+`.

Kronecker product `%x%`





**New Empty Matrix**

```R
# initialize an empty matrix
prediction_df <- matrix(ncol=7, nrow=0)
for (i in 1:10){
  the_prediction <- ...
  prediction_df <- rbind(prediction_df, the_prediction)
}

varImp_df <- matrix(ncol=0, nrow=4)
for (i in 1:10){
  varImp <- ...
	varImp_df <- bind_cols(varImp_df, varImp)
  # or cbind(varImp_df, varImp), bind_cols and cbind bind by positions
  # if need to match by namesm use left_join(varImp_df, varImp, by="name")
}
```

