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


## File Descriptions
- `a_study_in_scarlet.txt`: The text data of the book which I downloaded from 
- `fit_gaussian.html`: HTML export of the `main.ipynb` notebook.
- `presentation.mp4`: A brief video presentation discussing the work and key concepts of the project.


## Content
This project includes 7 parts in total, specifically: 
1. Synthesize a multimodal Gaussian distribution
2. Fit a piecewise linear regression model
3. Fit three spline models with 2, 3, and 4 knots respectively
4. Compare the R-squared values and root mean square deviations (RMSD) of the models from the previous sections
5. Fit four polynomial models with degree 2,3,4,5 respectively
6. Compare the fitting times of the constructed models
7. Construct two polynomial models of degree 5 using Lasso and Ridge regularization techniques

### For inquiries or further discussion, please reach out to me at [xihaocao@163.com](mailto:xihaocao@163.com). Thank you!

