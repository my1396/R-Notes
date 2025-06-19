# Load necessary libraries
library(MASS)    # for mvrnorm
library(ggplot2) # for plotting
library(reshape2) # for data reshaping
library(latex2exp)

# Parameters
mu <- c(0, 0)
# Covariance matrix with rho = 0
sigma <- c(0.5, 1)
rho <- 0.5
Sigma <- matrix(c(sigma[1]^2, rho*sigma[1]*sigma[2], 
                  rho*sigma[1]*sigma[2], sigma[2]^2), nrow = 2)  
Sigma
# Simulate data
set.seed(123)  # for reproducibility
data <- mvrnorm(n = 2000, mu = mu, Sigma = Sigma)
colnames(data) <- c("X1", "X2")

# Define bivariate normal PDF
bivariate_pdf <- function(x, y, mu, Sigma) {
    det_Sigma <- det(Sigma)
    inv_Sigma <- solve(Sigma)
    x_mu <- cbind(x - mu[1], y - mu[2])
    exp_term <- rowSums((x_mu %*% inv_Sigma) * x_mu)
    (1 / (2 * pi * sqrt(det_Sigma))) * exp(-0.5 * exp_term)
}

# Create grid
x_vals <- seq(-3, 3, length.out = 50)
y_vals <- seq(-3, 3, length.out = 50)
grid <- expand.grid(X1 = x_vals, X2 = y_vals)

# Evaluate PDF
grid$Z <- bivariate_pdf(grid$X1, grid$X2, mu, Sigma)

# Reshape data into a matrix for persp
z_matrix <- matrix(grid$Z, nrow = length(x_vals), byrow = FALSE)

f_name <- "images/nonspherical_disturbances_both.png"
f_name
png(f_name, width=1321*2, height=668*2, res=300)
par(mfrow=c(1,2))

col.pal <- colorRampPalette(c("blue", "red"))
colors <- col.pal(100)
# height of facets
z <- z_matrix
z.facet.center <- (z[-1, -1] + z[-1, -ncol(z)] + z[-nrow(z), -1] + z[-nrow(z), -ncol(z)])/4
# Range of the facet center on a 100-scale (number of colors)
z.facet.range <- cut(z.facet.center, 100)

# Surface plot using base R
persp(x = x_vals, y = y_vals, z = z_matrix,
      theta = 30, phi = 30,
      col = colors[z.facet.range], shade = NA,
      xlab =  "\u03B5i", ylab = "\u03B5j", zlab = "Density",
      main = "Surface Plot of Bivariate Normal PDF")
# Add model parameters as annotations below the plot
mtext(bquote(mu[i] == .(mu[1]) ~ ", " ~ mu[j] == .(mu[2]) ~ ", " ~ 
             sigma[i] == .(sigma[1]) ~ ", " ~ sigma[j] == .(sigma[2]) ~ ", " ~ 
             rho == .(rho)),
      side = 1, line = 2, cex = 0.9)

# Contour plot
contour(x = x_vals, y = y_vals, z = z_matrix,
        xlim = c(-3, 3), ylim = c(-3, 3),
        xlab = expression(epsilon[i]),  # Greek epsilon with subscript i
        ylab = expression(epsilon[j]),
        main = "Contour Plot of Bivariate Normal PDF",
        col = "blue", lwd = 2)
dev.off()



