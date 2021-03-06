% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/udpipe_parse.R
\name{udpipe}
\alias{udpipe}
\title{Tokenising, Lemmatising, Tagging and Dependency Parsing of raw text in TIF format}
\usage{
udpipe(x, object, parallel.cores = 1L, parallel.chunksize, ...)
}
\arguments{
\item{x}{either
\itemize{
 \item{a character vector: }{The character vector contains the text you want to tokenize, lemmatise, tag and perform dependency parsing. The names of the character vector indicate the document identifier.}
 \item{a data.frame with columns doc_id and text: }{The text column contains the text you want to tokenize, lemmatise, tag and perform dependency parsing. The doc_id column indicate the document identifier.}
 \item{a list of tokens: }{If you have already a tokenised list of tokens and you want to enrich it by lemmatising, tagging and performing dependency parsing. The names of the list indicate the document identifier.}
}
All text data should be in UTF-8 encoding}

\item{object}{either an object of class \code{udpipe_model} as returned by \code{\link{udpipe_load_model}},
the path to the file on disk containing the udpipe model or the language as defined by \code{\link{udpipe_download_model}}. 
If the language is provided, it will download the model using \code{\link{udpipe_download_model}}.}

\item{parallel.cores}{integer indicating the number of parallel cores to use to speed up the annotation. Defaults to 1 (use only 1 single thread). \cr
If more than 1 is specified, it uses parallel::mclapply (unix) or parallel::clusterApply (windows) to run annotation in parallel. In order to do this on Windows it runs first parallel::makeCluster to set up a local socket cluster, on unix it just uses forking to parallelise the annotation.\cr
Only set this if you have more than 1 CPU at disposal and you have large amount of data to annotate as setting up a parallel backend also takes some time plus 
annotations will run in chunks set by \code{parallel.chunksize} and for each parallel chunk the udpipe model will be loaded which takes also some time.\cr
If \code{parallel.cores} is bigger than 1 and \code{object} is of class \code{udpipe_model}, it will load the corresponding file from the model again in each parallel chunk.}

\item{parallel.chunksize}{integer with the size of the chunks of text to be annotated in parallel. If not provided, defaults to the size of \code{x} divided by \code{parallel.cores}. Only used in case \code{parallel.cores} is bigger than 1.}

\item{...}{other elements to pass on to \code{\link{udpipe_annotate}} and \code{\link{udpipe_download_model}}}
}
\value{
a data.frame with one row per doc_id and term_id containing all the tokens in the data, the lemma, the part of speech tags,
the morphological features and the dependency relationship along the tokens. The data.frame has the following fields:
\itemize{
 \item{doc_id: }{The document identifier.}
 \item{paragraph_id: }{The paragraph identifier which is unique within each document.}
 \item{sentence_id: }{The sentence identifier which is unique within each document.}
 \item{sentence: }{The text of the sentence of the sentence_id.}
 \item{start: }{Integer index indicating in the original text where the token starts. Missing in case of tokens part of multi-word tokens which are not in the text.}
 \item{end: }{Integer index indicating in the original text where the token ends. Missing in case of tokens part of multi-word tokens which are not in the text.}
 \item{term_id: }{A row identifier which is unique within the doc_id identifier.}
 \item{token_id: }{Token index, integer starting at 1 for each new sentence. May be a range for multiword tokens or a decimal number for empty nodes.}
 \item{token: }{The token.}
 \item{lemma: }{The lemma of the token.}
 \item{upos: }{The universal parts of speech tag of the token. See \url{https://universaldependencies.org/format.html}}
 \item{xpos: }{The treebank-specific parts of speech tag of the token. See \url{https://universaldependencies.org/format.html}}
 \item{feats: }{The morphological features of the token, separated by |. See \url{https://universaldependencies.org/format.html}}
 \item{head_token_id: }{Indicating what is the token_id of the head of the token, indicating to which other token in the sentence it is related. See \url{https://universaldependencies.org/format.html}}
 \item{dep_rel: }{The type of relation the token has with the head_token_id. See \url{https://universaldependencies.org/format.html}}
 \item{deps: }{Enhanced dependency graph in the form of a list of head-deprel pairs. See \url{https://universaldependencies.org/format.html}}
 \item{misc: }{SpacesBefore/SpacesAfter/SpacesInToken spaces before/after/inside the token. Used to reconstruct the original text. See \url{https://ufal.mff.cuni.cz/udpipe/1/users-manual}}
}
The columns paragraph_id, sentence_id, term_id, start, end are integers, the other fields
are character data in UTF-8 encoding. \cr
}
\description{
Tokenising, Lemmatising, Tagging and Dependency Parsing of raw text in TIF format
}
\examples{
model    <- udpipe_download_model(language = "dutch-lassysmall")
if(!model$download_failed){
ud_dutch <- udpipe_load_model(model)

## Tokenise, Tag and Dependency Parsing Annotation. Output is in CONLL-U format.
txt <- c("Dus. Godvermehoeren met pus in alle puisten, 
  zei die schele van Van Bukburg en hij had nog gelijk ook. 
  Er was toen dat liedje van tietenkonttieten kont tieten kontkontkont, 
  maar dat hoefden we geenseens niet te zingen. 
  Je kunt zeggen wat je wil van al die gesluierde poezenpas maar d'r kwam wel 
  een vleeswarenwinkel onder te voorschijn van heb je me daar nou.
  
  En zo gaat het maar door.",
  "Wat die ransaap van een academici nou weer in z'n botte pan heb gehaald mag 
  Joost in m'n schoen gooien, maar feit staat boven water dat het een gore 
  vieze vuile ransaap is.")
names(txt) <- c("document_identifier_1", "we-like-ilya-leonard-pfeiffer")

##
## TIF tagging: tag if x is a character vector, a data frame or a token sequence
##
x <- udpipe(txt, object = ud_dutch)
x <- udpipe(data.frame(doc_id = names(txt), text = txt, stringsAsFactors = FALSE), 
            object = ud_dutch)
x <- udpipe(strsplit(txt, "[[:space:][:punct:][:digit:]]+"), 
            object = ud_dutch)
       
## You can also directly pass on the language in the call to udpipe
x <- udpipe("Dit werkt ook.", object = "dutch-lassysmall")
x <- udpipe(txt, object = "dutch-lassysmall")
x <- udpipe(data.frame(doc_id = names(txt), text = txt, stringsAsFactors = FALSE), 
            object = "dutch-lassysmall")
x <- udpipe(strsplit(txt, "[[:space:][:punct:][:digit:]]+"), 
            object = "dutch-lassysmall")
}
            
## cleanup for CRAN only - you probably want to keep your model if you have downloaded it
if(file.exists(model$file_model)) file.remove(model$file_model)
}
\references{
\url{https://ufal.mff.cuni.cz/udpipe}, \url{https://lindat.mff.cuni.cz/repository/xmlui/handle/11234/1-2364}, 
\url{https://universaldependencies.org/format.html}
}
\seealso{
\code{\link{udpipe_load_model}}, \code{\link{as.data.frame.udpipe_connlu}}, \code{\link{udpipe_download_model}}, \code{\link{udpipe_annotate}}
}
