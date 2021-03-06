% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utilities.R
\name{amsweep}
\alias{amsweep}
\title{Sweep operator ###Check if we need to assign authorship to this###}
\usage{
amsweep(g, m, reverse = FALSE)
}
\arguments{
\item{g}{Each unit of a numeric, symmetric covariance matrix divided by
the number of observations in the data the covariance matrix was 
derived from.}

\item{m}{A logical vector of length equal to the number of rows in \code{g}
in which the \code{TRUE} values correspond to the x values in the matrix
and the \code{FALSE} values correspond to the y value in the matrix.}

\item{reverse}{Logical vector specifying whether the sign of the matrix 
should be flipped. Default to \code{FALSE}.}
}
\value{
The coefficients from \code{g}.
}
\description{
Sweeps a covariance matrix to extract regression coefficients.
}
