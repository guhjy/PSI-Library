#' Objective perturbation mechanism
#'
#' @import methods
#' @export mechanismObjective
#' @exportClass mechanismObjective
#'
#' @include mechanism.R

mechanismObjective <- setRefClass(
    Class = 'mechanismObjective',
    contains = 'mechanism'
)

mechanismObjective$methods(
    getFunArgs = function(fun) {
        callSuper(fun)
})

mechanismObjective$methods(
    evaluate = function(x, postFun, ...) {

        # subset data from formula
        cols <- all.vars(as.formula(.self$formula))
        x <- x[, cols]

        # censor & impute missing values
        x <- censordata(x, .self$var.type, .self$rng, .self$bins)
        x <- fillMissing2d(x, .self$var.type, .self$impute.rng)

        # extract X and y
        y <- x[, cols[1]]
        X <- x[, cols[2:length(cols)], drop=FALSE]
        X.names <- names(X)

        # scale inputs s.t. max Euclidean norm <= 1
        scaler <- mapMatrixUnit(X, p=2)
        X <- scaler$matrix

        # add intercept
        if (.self$intercept) {
            X <- cbind(1, X)
            X.names <- c('intercept', X.names)
        }

        # set start params, adjust for ols
        if (.self$name == 'ols') {
            start.params <- rep(0, ncol(X) + 1)
            X.names <- c(X.names, 'variance')
            y.scaler <- mapMatrixUnit(y, p=2)
            y <- y.scaler$matrix
            y.max.norm <- y.scaler$max.norm
        } else {
            start.params <- rep(0, ncol(X))
            y.max.norm <- NULL
        }

        # fit
        if (is.null(.self$n.boot)) {
            b.norm <- dpNoise(n=1, scale=(2 / .self$epsilon), dist='gamma', shape=length(start.params))
            b <- dpNoise(n=length(start.params), scale=(-.self$epsilon * b.norm), dist='laplace')
            estimates <- optim(par=start.params, fn=.self$objective, X=X, y=y, b=b, n=n)$par
            release <- data.frame(scaleRelease(estimates, scaler$max.norm, y.max.norm))
            names(release) <- 'estimate'
            rownames(release) <- X.names
        } else {
            local.epsilon <- .self$epsilon / .self$n.boot
            release <- vector('list', .self$n.boot)
            for (i in 1:.self$n.boot) {
                index <- sample(1:.self$n, .self$n, replace=TRUE)
                X.star <- X[index, ]
                y.star <- y[index]
                b.norm <- dpNoise(n=1, scale=(2 / local.epsilon), dist='gamma', shape=length(start.params))
                b <- dpNoise(n=length(start.params), scale=(-local.epsilon * b.norm), dist='laplace')
                estimates <- optim(par=start.params, fn=.self$objective, X=X.star, y=y.star, b=b, n=n)$par
                release[[i]] <- scaleRelease(estimates, scaler$max.norm, y.max.norm)
            }
            release <- data.frame(do.call(rbind, release))
            names(release) <- X.names
        }

        # format output
        out <- list('release' = release)
        out <- postFun(out, ...)
        return(out)
})
