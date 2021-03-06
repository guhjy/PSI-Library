#' Base mechanism class
#'
#' @import methods
#' @export mechanism
#' @exportClass mechanism
#'
#' @field mechanism Name of the mechanism
#' @field name Name of the statistic
#' @field variable Name of the variable
#' @field var.type Variable type
#' @field var.type.orig Variable type at instantiation
#' @field n Number of observations
#' @field epsilon Differential privacy parameter
#' @field delta Differential privacy parameter
#' @field rng A priori estimate of the variable range
#' @field result List with statistical output
#' @field alpha Level of statistical signficance
#' @field accuracy Accuracy guarantee of the estimate
#' @field bins Bins
#' @field n.bins Number of bins
#' @field k Number of bins desired for the release
#' @field error Error
#' @field n.boot Number of bootstrap replications
#' @field boot.fun Function passed to the bootstrap mechanism
#' @field impute.rng The range from which to impute missing values
#' @field impute Logical, impute categorical types?
#' @field formula R formula for regression models
#' @field columns Vector of column names
#' @field intercept Logical, is the intercept included?
#' @field stability Logical, use stability histogram
#' @field objective Objective function for regression models
#' @field gran Granularity
#' @field percentiles Percentiles evaluated by binary tree
#' @field tree.data Binary tree attributes needed for efficient estimation

mechanism <- setRefClass(
    Class = 'mechanism',
    fields = list(
        mechanism = 'character',
        name = 'character',
        variable = 'character',
        var.type = 'character',
        var.type.orig = 'character',
        n = 'numeric',
        epsilon = 'numeric',
        delta = 'numeric',
        rng = 'ANY',
        result = 'ANY',
        alpha = 'numeric',
        accuracy = 'numeric',
        bins = 'ANY',
        n.bins = 'ANY',
        k = 'numeric',
        error = 'numeric',
        n.boot = 'ANY',
        boot.fun = 'function',
        impute.rng = 'ANY',
        impute = 'logical',
        formula = 'ANY',
        columns = 'ANY',
        intercept = 'logical', 
        stability = 'logical',
        objective = 'function',
        gran = 'numeric',
        percentiles = 'ANY',
        tree.data = 'ANY'
))

mechanism$methods(
    getFields = function() {
        f <- names(getRefClass()$fields())
        out <- setNames(vector('list', length(f)), f)
        for (fd in f) {
            out[[fd]] <- .self[[fd]]
        }
        return(out)
})

mechanism$methods(
    getFunArgs = function(fun) {
        f <- .self$getFields()
        spec <- list()
        for (arg in names(f)) {
            if (arg %in% names(formals(fun))) {
                spec[[arg]] <- f[[arg]]
            }
        }
        return(spec)
})
