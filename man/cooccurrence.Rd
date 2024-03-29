% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/nlp_cooccurrence.R
\name{cooccurrence}
\alias{cooccurrence}
\alias{cooccurrence.character}
\alias{cooccurrence.cooccurrence}
\alias{cooccurrence.data.frame}
\title{Create a cooccurence data.frame}
\usage{
cooccurrence(x, order = TRUE, ...)

\method{cooccurrence}{character}(
  x,
  order = TRUE,
  ...,
  relevant = rep(TRUE, length(x)),
  skipgram = 0
)

\method{cooccurrence}{cooccurrence}(x, order = TRUE, ...)

\method{cooccurrence}{data.frame}(x, order = TRUE, ..., group, term)
}
\arguments{
\item{x}{either
\itemize{
  \item a data.frame where the data.frame contains 1 row per document/term,
  in which case you need to provide \code{group} and \code{term} where \code{term} is the column containing 1 term per row
  and \code{group} indicates something like a document id or document + sentence id. This uses cooccurrence.data.frame.
  \item a character vector with terms where one element contains 1 term. This uses cooccurrence.character.
  \item an object of class \code{cooccurrence}. This uses cooccurrence.cooccurrence.
}}

\item{order}{logical indicating if we need to sort the output from high cooccurrences to low coccurrences. Defaults to TRUE.}

\item{...}{other arguments passed on to the methods}

\item{relevant}{a logical vector of the same length as \code{x}, indicating if the word in \code{x} is relevant or not.
This can be used to exclude stopwords from the cooccurrence calculation or selecting only nouns and adjectives to 
find cooccurrences along with each other 
(for example based on the Parts of Speech \code{upos} output from \code{udpipe_annotate}).\cr
Only used if calculating cooccurrences on \code{x} which is a character vector of words.}

\item{skipgram}{integer of length 1, indicating how far in the neighbourhood to look for words.\cr
\code{skipgram} is considered the maximum skip distance between words to calculate co-occurrences 
(where co-occurrences are of type skipgram-bigram, where a skipgram-bigram are 2 words which occur at a distance of at most \code{skipgram + 1} from each other). \cr
Only used if calculating cooccurrences on \code{x} which is a character vector of words.}

\item{group}{character vector of columns in the data frame \code{x} indicating to calculate cooccurrences within these columns. \cr
This is typically a field like document id or a sentence identifier. To be used if \code{x} is a data.frame.}

\item{term}{character string of a column in the data frame \code{x}, containing 1 term per row. To be used if \code{x} is a data.frame.}
}
\value{
a data.frame with columns term1, term2 and cooc indicating
for the combination of term1 and term2 how many times this combination occurred
}
\description{
A cooccurence data.frame indicates how many times each term co-occurs with another term.\cr

There are 3 types of cooccurrences:
\itemize{
  \item Looking at which words are located in the same document/sentence/paragraph.
  \item Looking at which words are followed by another word
  \item Looking at which words are in the neighbourhood of the word as in follows the word within \code{skipgram} number of words
}
The output of the function gives a cooccurrence data.frame which contains the fields term1, term2 and cooc where cooc indicates how many times
term1 and term2 co-occurred. This dataset can be constructed 
\itemize{
  \item based upon a data frame where you look within a group (column of the data.frame) if 2 terms occurred in that group.
  \item based upon a vector of words in which case we look how many times each word is followed by another word.
  \item based upon a vector of words in which case we look how many times each word is followed by another word or is followed by another word if we skip a number of words in between.
}
Note that 
\itemize{
  \item For cooccurrence.data.frame no ordering is assumed which implies that the function does not return self-occurrences if a word occurs several times in the same group of text and term1 is always smaller than term2 in the output
  \item For cooccurrence.character we assume text is ordered from left to right, the function as well returns self-occurrences
}
You can also aggregate cooccurrences if you decide to do any of these 3 by a certain group and next want to obtain an overall aggregate.
}
\section{Methods (by class)}{
\itemize{
\item \code{character}: Create a cooccurence data.frame based on a vector of terms

\item \code{cooccurrence}: Aggregate co-occurrence statistics by summing the cooc by term/term2

\item \code{data.frame}: Create a cooccurence data.frame based on a data.frame where you look within a document / sentence / paragraph / group 
if terms co-occur
}}

\examples{
\dontshow{
data.table::setDTthreads(1)
}
data(brussels_reviews_anno)

## By document, which lemma's co-occur
x <- subset(brussels_reviews_anno, xpos \%in\% c("NN", "JJ") & language \%in\% "fr")
x <- cooccurrence(x, group = "doc_id", term = "lemma")
head(x)

## Which words follow each other
x <- c("A", "B", "A", "A", "B", "c")
cooccurrence(x)

data(brussels_reviews_anno)
x <- subset(brussels_reviews_anno, language == "es")
x <- cooccurrence(x$lemma)
head(x)
x <- subset(brussels_reviews_anno, language == "es")
x <- cooccurrence(x$lemma, relevant = x$xpos \%in\% c("NN", "JJ"), skipgram = 4)
head(x)

## Which nouns follow each other in the same document
library(data.table)
x <- as.data.table(brussels_reviews_anno)
x <- subset(x, language == "nl" & xpos \%in\% c("NN"))
x <- x[, cooccurrence(lemma, order = FALSE), by = list(doc_id)]
head(x)

x_nodoc <- cooccurrence(x)
x_nodoc <- subset(x_nodoc, term1 != "appartement" & term2 != "appartement")
head(x_nodoc)
}
