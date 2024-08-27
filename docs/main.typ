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
  let supplement = ""
  let ch = it.element
  let num = counter(heading).at(ch.location())

  v(16pt, weak: true)

  if 0 in num {
    strong(it.element.body + h(0.2em) + box(width: 1fr) + h(0.2em)) + numbering("i", ch.location().page())
  } else if 100 in num {
    strong(it.element.body + h(0.2em) + box(width: 1fr) + h(0.2em) + numbering("1", ch.location().page()))
  } else if (it.element.body.has("text")) {
    strong(text(supplement) + numbering("1", ..num) + ". " + it.element.body.text + h(0.2em) + box(width: 1fr) + h(0.2em) + it.page)
  } else {
    it
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

  show outline.entry.where(
    level: 1
  ): it => {
    it
  }

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
#let loremAvg = 400

= Giới thiệu <start>

== Bài toán lập lịch sự kiện có chu kỳ


= Background

== Logic mệnh đề
=== Mệnh đề và đại số Bool

#lorem(loremAvg)

=== Chuẩn tắc hội

#lorem(loremAvg)

== SAT
=== SAT Problem

#lorem(loremAvg)

=== SAT encodings và ứng dụng

#lorem(loremAvg)

== PESP
=== Interval

#lorem(loremAvg)

=== Constaints

#lorem(loremAvg)

=== Period Event Network

#lorem(loremAvg)

=== Existing appoachs

#lorem(loremAvg)

= Model PESP as SAT

== Direct encoding

=== Encode finite variable in SAT domain

#lorem(loremAvg)

=== Encode constraint

#lorem(loremAvg)

== Order encoding

=== Encode finite variable in order domain

#lorem(loremAvg)

=== Encode constraint

#lorem(loremAvg)

== Optimizations

#lorem(loremAvg)

== Comparision

#lorem(loremAvg)

= Experiments and results

== Model railway network as PESP

#lorem(loremAvg)

== Setup and Dataset

#lorem(loremAvg)

== Results and Analaysis

#lorem(loremAvg)

= Conclusions

== Conclusions

#lorem(loremAvg)

== Future work

#lorem(loremAvg)


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

#lorem(60)

#pagebreak()

#show heading.where(
  depth: 1
): it => pad(text(it.body, size: 24pt), x: 0pt, y: 40pt)

#set heading(numbering: none)
#counter(heading).update(100)

#bibliography("citation.bib")