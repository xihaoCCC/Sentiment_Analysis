# Sentiment Analysis of <A Study in Scarlet>

## Summary
In this project, I undertook a sentiment analysis of the famous detective novel, "A Study in Scarlet." I performed both 
sentence-level and token-level sentiment analyses. The former evaluates the sentiment score of entire sentences or word 
clusters, whereas the latter assesses individual words.

I employed a range of tools and visual techniques to explore the novel's word-sentence dynamics and sentiment fluctuations. 
The analysis utilizes four widely recognized text mining lexicon engines: afinn, NRC, bing, and loughran. Each of these engines
offers distinct sentiment keyword categories and methodologies to examine the positivity of words.


## Setup
Ensure you have **R**, **RStudio**, and **LaTeX** installed. Install the R packages mentioned in `sentence_report.Rmd` and `token_report.Rmd`. 
Two notable packages include:
- **gutenbergr**: Provides access to the Gutenberg library, which contains over 70,000 free eBooks.
- **tnum**: Developed by Boston University professors for vectorized parsing of extensive texts. This package requires users to have access to the Boston University server.

After setting up the packages, open the `.Rmd` files in RStudio and use the `knit` function to generate the respective reports in PDF format.


## File Descriptions:
- `a_study_in_scarlet.txt`: Text data of the book.
- `sentence_report.Rmd`: R script for sentence-level sentiment analysis.
- `sentence_report.pdf`: Sentence-level sentiment analysis report (PDF format).
- `token_report.Rmd`: R script for token-level sentiment analysis.
- `token_report.pdf`: Token-level sentiment analysis report (PDF format).

### For inquiries or further discussion, please reach out to me at [xihaocao@163.com](mailto:xihaocao@163.com). Thank you!

