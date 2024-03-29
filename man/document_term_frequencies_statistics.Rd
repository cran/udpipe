% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/nlp_flow.R
\name{document_term_frequencies_statistics}
\alias{document_term_frequencies_statistics}
\title{Add Term Frequency, Inverse Document Frequency and Okapi BM25 statistics to the output of document_term_frequencies}
\usage{
document_term_frequencies_statistics(x, k = 1.2, b = 0.75)
}
\arguments{
\item{x}{a data.table as returned by \code{document_term_frequencies} containing the columns doc_id, term and freq.}

\item{k}{parameter k1 of the Okapi BM25 ranking function as defined at \url{https://en.wikipedia.org/wiki/Okapi_BM25}. Defaults to 1.2.}

\item{b}{parameter b of the Okapi BM25 ranking function as defined at \url{https://en.wikipedia.org/wiki/Okapi_BM25}. Defaults to 0.5.}
}
\value{
a data.table with columns doc_id, term, freq and added to that the computed statistics
tf, idf, tfidf, tf_bm25 and bm25.
}
\description{
Term frequency Inverse Document Frequency (tfidf) is calculated as the multiplication of
\itemize{
\item Term Frequency (tf): how many times the word occurs in the document / how many words are in the document
\item Inverse Document Frequency (idf): log(number of documents / number of documents where the term appears)
}
The Okapi BM25 statistic is calculated as the multiplication of the inverse document frequency
and the weighted term frequency as defined at \url{https://en.wikipedia.org/wiki/Okapi_BM25}.
}
\examples{
data(brussels_reviews_anno)
\dontshow{
data.table::setDTthreads(1)
brussels_reviews_anno <- subset(brussels_reviews_anno, language \%in\% "nl")
}
x <- document_term_frequencies(brussels_reviews_anno[, c("doc_id", "token")])
x <- document_term_frequencies_statistics(x)
head(x)
}
