#set page(paper: "a4", margin: (top: 2.5cm, bottom: 3cm, left: 2.5cm, right: 2cm), numbering: "1")

#set page(
    footer: locate(
      loc => {
        let page-number = counter(page).at(loc).first()
        let match-list = query(selector(<start>).before(loc), loc)
        if match-list == () { return align(center, str(numbering("i", page-number))) }
        align(center, str(page-number))
      },
    ),
  )

#set text(lang: "vi", font: "Latin Modern Roman 12", size: 13pt)

// #set text(lang: "vi", font: "Times New Roman", size: 13pt)
#set block(spacing: 1.56em)
#set par(first-line-indent: 1cm, justify: true, leading: 0.845em)




#show heading.where(depth: 1): it => pad({
  box(width: 35pt, counter(heading).display())
  it.body
}, y: 16pt)

#show heading.where(
  depth: 1
): it => block(width: 100%)[
  #pad(block(text(it.body, size: 23pt)), y: 32pt, bottom: 36pt)
]

// Title page
#{

show: block.with(stroke: 3pt, width: 100%, height: 100%, inset: 20pt)
place(top+left, rect(width: 100%, height: 100%,outset:20pt - 0.15cm, stroke: 1pt))
set align(center)


let author = "Phạm Văn Phúc"
let title = "Nghiên cứu bài toán PESP áp dụng để lập lịch giờ tàu điện chạy"

let advisor = "Tô Văn Khánh"

// rect(width: 100%, height: 100%, "Hello")

stack(dir: ttb,

spacing: 2em,

stack(dir: ttb, spacing: 6pt, align(upper(text("Đại học quốc gia Hà Nội", size: 12pt, weight: "bold")), center), align(upper(text("Trường đại học công nghệ", size: 12pt, weight: "bold")), center)),
pad(align(image("image/Logo_HUET.svg", fit: "contain", width: 24%), center)),

pad((text(author, size: 14pt, weight: "bold")), y: 2em),

pad(upper(text(title, size: 18pt, weight: "bold")), y: 4em),

stack(
  dir: ttb,
  spacing: 10pt,
  pad(align(center+top)[#text("Ngành: Công nghệ thông tin", weight: "bold", size: 14pt)]),
)

)

align(center+bottom)[#text("HÀ NỘI - 2024", weight: "bold", size: 12pt)]
}
#pagebreak(weak: true)

#{

show: block.with(stroke: 3pt, width: 100%, height: 100%, inset: 20pt)
place(top+left, rect(width: 100%, height: 100%,outset:20pt - 0.15cm, stroke: 1pt))
set align(center)


let author = "Phạm Văn Phúc"
let title = "Nghiên cứu bài toán PESP áp dụng để lập lịch giờ tàu điện chạy"

let advisor = "Tô Văn Khánh"

// rect(width: 100%, height: 100%, "Hello")

stack(dir: ttb,

spacing: 2em,

stack(dir: ttb, spacing: 6pt, align(upper(text("Đại học quốc gia Hà Nội", size: 12pt, weight: "bold")), center), align(upper(text("Trường đại học công nghệ", size: 12pt, weight: "bold")), center)),

pad((text(author, size: 14pt, weight: "bold")), y: 2em),

pad(upper(text(title, size: 18pt, weight: "bold")), y: 4em),

stack(
  dir: ttb,
  spacing: 10pt,
  pad(align(center+top)[#text("Ngành: Công nghệ thông tin", weight: "bold", size: 14pt)]),
),

pad(align(text("Cán bộ hướng dẫn: " + advisor, weight: "bold"), left), top: 6em)

)

align(center+bottom)[#text("HÀ NỘI - 2024", weight: "bold", size: 12pt)]
}
#pagebreak(weak: true)


// Start numbering at this section
#counter(page).update(1)
#set heading(numbering: none)
= Tóm tắt 


#lorem(160)

*Từ khóa: * SAT, MaxSAT, lập lịch, lập lịch thời khóa biểu cho đại học

#pagebreak()


= Lời cảm ơn

#lorem(160)

#pagebreak()

= Lời cam đoan

#lorem(160)

#pagebreak()

#show outline.entry.where(
  level: 1
): it => {

  if (type(it.element) == figure) {
    it
  }


  // set text(size: 14pt)
  let supplement = ""
  let ch = it.element
  // we need the chapter number, i.e. the heading counter at the location the original heading appeared
  let num = counter(heading).at(ch.location())

  let match-list = query(
    selector(heading).before(<start>), it.location(),
  )

  v(16pt, weak: true)

  if 0 in num {
    strong(it.element.body + h(0.2em) + box(width: 1fr) + h(0.2em) + numbering("i", ch.location().page()))
  } else if 100 in num {
    strong(it.element.body + h(0.2em) + box(width: 1fr) + h(0.2em) + numbering("1", ch.location().page()))
  } else {
    strong(text(supplement) + numbering("1", ..num) + ". " + it.element.body + h(0.2em) + box(width: 1fr) + h(0.2em) + it.page)
  }
}

#outline(indent: auto)

#pagebreak()


#{
  show heading: set heading(outlined: true)
  heading("Danh mục viết tắt")
}

#lorem(160)

#pagebreak()

#{
  outline(
  title: [Danh mục hình ảnh],
  target: figure.where(kind: image),
)
}


#pagebreak()


#{
  outline(
  title: [Danh mục bảng biểu],
  target: figure.where(kind: table),
)
}


#pagebreak()


#show heading.where(
  depth: 1
): it => block(width: 100%)[
  #block(upper(text(weight: "light", size: 11.5pt,"Chương " + counter(heading).display())))
  #pad(block(text(it.body, size: 23pt)), y: 32pt, bottom: 36pt)
]

#counter(page).update(1)
#counter(heading).update(0)
#set heading(numbering: "1.1.1")
= Giới thiệu <start>


This chapter will focuses on introducing the itemset mining tasks in data min-
ing, the concepts, applications, and challenges of frequent itemset mining. Further-
more, the chapter also provides a survey of frequent itemset mining algorithms @hoare1962quicksort.

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

#figure(
  image("image/myownspell.jpg"),
  caption: [A nice figure!],
)

#figure(
  table(
  columns: (1fr, 1fr),
  inset: 10pt,
  align: horizon + center,
  table.header(
    [*Math*], [*SAT (direct)*],
  ),
  $ pi = i, i in [0, T - 1], 
   pi in ZZ, i in ZZ $,
  $ p_(i) = #true, p_(j) = #false forall j != i, 0 <= j < T $,
  $ pi = i, i in [0, T - 1], 
   pi in ZZ, i in ZZ $,
  $ (or.big_(i = 0)^(i < T) p_i ) and (and.big_(i=0)^(i < T) and.big_(j = 0, j != i)^(j < T) p_i => not p_j) $,
  $ pi = i, i in [0, T - 1], 
   pi in ZZ, i in ZZ $,
  $ (or.big_(i = 0)^(i < T) p_i ) and (and.big_(i=0)^(i < T) and.big_(j = 0, j != i)^(j < T) not p_i or not p_j) $,
), caption: "Table test"
)

#pagebreak()

= Logic mệnh đề

= Bài toán lập lịch sự kiện có chu kỳ

= SAT

== Some thing

#lorem(60)

#pagebreak()

#show heading.where(
  depth: 1
): it => pad(text(it.body, size: 24pt), x: 0pt, y: 40pt)

#set heading(numbering: none)
#counter(heading).update(100)

#bibliography("citation.bib")