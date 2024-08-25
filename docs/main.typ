#set page(paper: "a4", margin: (top: 2.5cm, bottom: 3cm, left: 2.5cm, right: 2cm), numbering: "1")
#set text(lang: "vi", font: "Latin Modern Roman 12", size: 13pt)

// #set text(lang: "vi", font: "Times New Roman", size: 13pt)
#set block(spacing: 1.56em)
#set par(first-line-indent: 1cm, justify: true, leading: 0.845em)

#set heading(numbering: "1.1.1")

#show heading: it => pad({
  box(width: 35pt, counter(heading).display())
  it.body
}, y: 16pt)

#show heading.where(
  depth: 1
): it => block(width: 100%)[
  #block(upper(text(weight: "light", size: 11.5pt,"Chương " + counter(heading).display())))
  #pad(block(text(it.body, size: 23pt)), y: 32pt, bottom: 36pt)
]

= Introduction

This chapter will focuses on introducing the itemset mining tasks in data min-
ing, the concepts, applications, and challenges of frequent itemset mining. Further-
more, the chapter also provides a survey of frequent itemset mining algorithms.

== Frequent Itemset Mining


Data mining[9] is concerned with either forecasting future trends or decipher-
ing past events. Techniques used for predicting the future, such as neural networks,
often function as black-box models because the primary objective is to achieve the
highest possible accuracy rather than explainability. On the other hand, various
data mining methods aim to uncover patterns in data that are straightforward for
humans to interpret.

These methods of pattern discovery can be categorized based on the specific
types of patterns they identify, including clusters, itemsets, trends, and outliers.
For example, clusters group similar data points together, itemsets identify common
associations or groupings in data, trends reveal changes or movements over time,
and outliers pinpoint unusual or unexpected data points.

This paper provides a survey that focuses specifically on the discovery of item-
sets within databases. Itemset discovery is a popular data mining task, especially
when analyzing symbolic data, as it can provide valuable insights into associations
and relationships within datasets.

The concept of discovering itemsets in databases was introduced in 1993 by
Agrawal and Srikant under the term large itemset mining, which is now known as
1frequent itemset mining (FIM). The objective of FIM is to identify groups of items
(itemsets) that often occur together within customer transactions.

For example, analyzing a customer transaction database may reveal that many
customers purchase taco shells along with peppers. Recognizing these associations
between items helps to shed light on customer behavior. This knowledge can be
invaluable for retail managers, as it enables them to make strategic marketing
decisions such as promoting products together or positioning them closer on store
shelves. Such strategies can lead to enhanced customer experiences and potentially
increased sales.
Frequent itemset mining (FIM) was initially proposed as a method for an-
alyzing customer transaction data, but it has since evolved into a general data
mining task that is applicable across various domains. In broader terms, a cus-
tomer transaction database can be seen as a collection of instances representing
objects (transactions), with each object characterized by nominal attribute val-
ues (items). As such, FIM can also be understood as the process of identifying
attribute values that commonly occur together in a database.
Given that many data types can be represented in the form of transaction
databases, FIM finds applications across a diverse range of fields. These include
bioinformatics, image classification, network traffic analysis, customer review anal-
ysis, activity monitoring, malware detection, and e-learning, among others.
FIM has also been extended in numerous ways to cater to specific require-
ments and challenges within these domains. For example, extensions of FIM have
been developed to discover rare patterns, correlated patterns, patterns in sequences
and graphs, and patterns that yield high profit. These adaptations expand the ap-
plicability of FIM and demonstrate its versatility and relevance across different
areas of data mining.

=== Concepts
Frequent item sets ar


#pagebreak()
= SAT

== Some thing

#lorem(60)