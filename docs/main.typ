#set page(paper: "a4", margin: (top: 2.5cm, bottom: 3cm, left: 2.5cm, right: 2cm), numbering: "1")



// Bỏ qua đánh số trang ở 2 trang bìa. Bắt đầu từ "Tóm tắt" bằng số la mã và đánh số còn lại bằng số latinh. 
// Tại sao á? khóa luận khác nó như thế
#set page(
  footer: locate(loc => {
    let page-number = counter(page).at(loc).first()
    let before-start = query(selector(<start>).before(loc), loc)

    let before-page-start = query(selector(<page-start>).before(loc), loc)

    if before-page-start == () {
      none
    } else if before-start == () {
      align(center, str(numbering("i", page-number)))
    } else {
      align(center, str(page-number))
    }
  }),
)

#set text(lang: "vi", font: "Latin Modern Roman 12", size: 13pt)

// #set text(lang: "vi", font: "Times New Roman", size: 13pt)
#set block(spacing: 1.56em)
#set par(first-line-indent: 1cm, justify: true, leading: 0.845em)




#show heading.where(depth: 1): it => pad(
  {
    box(width: 35pt, counter(heading).display())
    it.body
  },
  y: 16pt,
)

#show heading.where(depth: 1): it => block(width: 100%)[
  #pad(block(text(it.body, size: 23pt)), y: 32pt, bottom: 36pt)
]

// Title page
#{

  show: block.with(stroke: 3pt, width: 100%, height: 100%, inset: 20pt)
  place(top + left, rect(width: 100%, height: 100%, outset: 20pt - 0.15cm, stroke: 1pt))
  set align(center)


  let author = "Phạm Văn Phúc"
  let title = "Nghiên cứu bài toán PESP áp dụng để lập lịch giờ tàu điện chạy"

  let advisor = "Tô Văn Khánh"

  // rect(width: 100%, height: 100%, "Hello")

  stack(
    dir: ttb,

    spacing: 2em,

    stack(
      dir: ttb,
      spacing: 6pt,
      align(upper(text("Đại học quốc gia Hà Nội", size: 12pt, weight: "bold")), center),
      align(upper(text("Trường đại học công nghệ", size: 12pt, weight: "bold")), center),
    ),
    pad(align(image("image/Logo_HUET.svg", fit: "contain", width: 24%), center)),

    pad((text(author, size: 14pt, weight: "bold")), y: 2em),

    pad(upper(text(title, size: 18pt, weight: "bold")), y: 4em),

    stack(
      dir: ttb,
      spacing: 10pt,
      pad(align(center + top)[#text("Ngành: Công nghệ thông tin", weight: "bold", size: 14pt)]),
    ),
  )

  align(center + bottom)[#text("HÀ NỘI - 2024", weight: "bold", size: 12pt)]
}
#pagebreak(weak: true)

#{

  show: block.with(stroke: 3pt, width: 100%, height: 100%, inset: 20pt)
  place(top + left, rect(width: 100%, height: 100%, outset: 20pt - 0.15cm, stroke: 1pt))
  set align(center)


  let author = "Phạm Văn Phúc"
  let title = "Nghiên cứu bài toán PESP áp dụng để lập lịch giờ tàu điện chạy"

  let advisor = "Tô Văn Khánh"

  // rect(width: 100%, height: 100%, "Hello")

  stack(
    dir: ttb,

    spacing: 2em,

    stack(
      dir: ttb,
      spacing: 6pt,
      align(upper(text("Đại học quốc gia Hà Nội", size: 12pt, weight: "bold")), center),
      align(upper(text("Trường đại học công nghệ", size: 12pt, weight: "bold")), center),
    ),

    pad((text(author, size: 14pt, weight: "bold")), y: 2em),

    pad(upper(text(title, size: 18pt, weight: "bold")), y: 4em),

    stack(
      dir: ttb,
      spacing: 10pt,
      pad(align(center + top)[#text("Ngành: Công nghệ thông tin", weight: "bold", size: 14pt)]),
    ),

    pad(align(text("Cán bộ hướng dẫn: " + advisor, weight: "bold"), left), top: 6em),
  )

  align(center + bottom)[#text("HÀ NỘI - 2024", weight: "bold", size: 12pt)]
}
#pagebreak(weak: true)


// Start numbering at this section
#counter(page).update(1)
#set heading(numbering: none)
= Tóm tắt <page-start>


Hiện nay, các bộ giải SAT đã cải thiện đáng kể và được áp dụng thành công nhằm giải quyết các vấn đề thực tế, không trực tiếp liên quan đến logic mệnh đề. Vấn đề lập lịch sự kiện định kỳ (PESP) từ lâu đã được chương minh là một vấn đề NP đầy đủ. Các phương pháp hiện tại như ràng lập trình ràng buộc (Constraint satisfaction problem) hay quy hoạch số nguyên (Integer Programing) chưa thực sự hiệu quả với các bộ dự liệu lớn.
Tài liệu này sẽ trình bày thuật toán chuyển hóa vấn đề lập lịch định kỳ (PESP) về bài toán SAT, sau đó được xử lý bởi các bộ giải SAT nhằm đạt được hiệu suất cao hơn.


*Từ khóa: * Periodic railway timetabling; Optimisation; Periodic Event Scheduling Problem; SAT

#pagebreak()


= Lời cảm ơn

Quá trình thực hiện đề tài khóa luận tốt nghiệp là một hành trình đầy ý nghĩa và thử thách. Em xin gửi lời cảm ơn chân thành nhất đến tất cả những người đã đồng hành cùng em trong suốt thời gian qua. Đặc biệt, em xin bày tỏ lòng biết ơn sâu sắc đến thầy Tô Văn Khánh. Chính sự tận tâm hướng dẫn, những góp ý quý báu và kinh nghiệm phong phú của thầy đã giúp em định hình rõ hơn vấn đề nghiên cứu và vượt qua nhiều khó khăn. Em luôn trân trọng những buổi trao đổi cùng thầy, khi thầy không chỉ truyền đạt kiến thức chuyên môn mà còn giúp em rèn luyện tư duy khoa học.

Em cũng xin gửi lời cảm ơn đến toàn thể quý thầy cô, cán bộ giảng viên trường Đại học Công Nghệ. Nhờ sự tận tình giảng dạy của thầy cô, em đã có được hành trang kiến thức vững chắc để bước vào nghiên cứu. Môi trường học tập thân thiện và cơ sở vật chất hiện đại của nhà trường đã tạo điều kiện thuận lợi cho em hoàn thành tốt khóa luận.

Cuối cùng, em xin kính chúc các thầy cô luôn mạnh khỏe, hạnh phúc và gặt hái nhiều thành công hơn nữa trong sự nghiệp trồng người cao quý.

#v(1em)

#grid(
  columns: (2fr, 1fr),
  align: center,
  inset: 10pt,
  gutter: 30pt,
  "", "Sinh viên", "", "Phạm Văn Phúc"
)


#pagebreak()

= Lời cam đoan

Em xin cam đoan khóa luận tốt nghiệp là của em, do em thực hiện dưới sự hướng
dẫn của TS. Tô Văn Khánh. Tất cả tham khảo, nghiên cứu
và tài liệu liên quan đều được nêu rõ ràng và chi tiết trong danh mục tài liệu tham khảo.
Các nội dung trình bày trong khóa luận này là hoàn toàn trung thực.

#v(1em)

#grid(
  columns: (2fr, 1fr),
  align: center,
  inset: 10pt,
  gutter: 30pt,
  "", "Sinh viên", "", "Phạm Văn Phúc"
)


#pagebreak()

#show outline.entry.where(level: 1): it => {
  let supplement = ""
  let ch = it.element
  let num = counter(heading).at(ch.location())

  v(16pt, weak: true)

  if 0 in num {
    strong(it.element.body + h(0.2em) + box(width: 1fr) + h(0.2em)) + numbering("i", ch.location().page())
  } else if 100 in num {
    strong(it.element.body + h(0.2em) + box(width: 1fr) + h(0.2em) + numbering("1", ch.location().page()))
  } else if (it.element.body.has("text")) {
    strong(text(supplement) + numbering("1", ..num) + ". " + it
      .element
      .body
      .text + h(0.2em) + box(width: 1fr) + h(0.2em) + it.page)
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

// FIXME with this
// https://typst.app/universe/package/acrotastic/

#lorem(160)

#pagebreak()

#{

  show outline.entry.where(level: 1): it => {
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


#show heading.where(depth: 1): it => block(width: 100%)[
  #block(upper(text(weight: "light", size: 11.5pt, "Chương " + counter(heading).display())))
  #pad(block(text(it.body, size: 23pt)), y: 32pt, bottom: 36pt)
]

#counter(page).update(1)
#counter(heading).update(0)
#set heading(numbering: "1.1.1")
#let loremAvg = 400

= Giới thiệu <start>

== Bài toán xây dựng lịch trình tàu


== Các tiêu chí và mục tiêu trong việc xây dựng lịch trình tàu


== Vấn đề lập lịch sự kiện định kỳ

=== Interval

#lorem(loremAvg)

=== Constaints

#lorem(loremAvg)

=== Period Event Network

#lorem(loremAvg)

=== Các giải pháp hiện tại

#lorem(loremAvg)

= Kiến thức nền tảng

== Logic mệnh đề
=== Mệnh đề và đại số Bool

#lorem(loremAvg)

=== Chuẩn tắc hội

#lorem(loremAvg)

== SAT
=== Vấn đề 3-SAT

#lorem(loremAvg)

=== SAT Solver

#lorem(loremAvg)

=== SAT encoding và ứng dụng

= Mô hình bài toán PESP về bài toán SAT

== Binominal encoding

=== Mã hóa sự kiện

#lorem(loremAvg)

=== Mã hóa ràng buộc

#lorem(loremAvg)

== Order encoding

=== Mã hóa sự kiện

#lorem(loremAvg)

=== Mã hóa ràng buộc

#lorem(loremAvg)

=== Tối ưu thuật toán mã hóa ràng buộc

#lorem(loremAvg)

== So sánh Binominal encoding và Order encoding

=== Số biến

=== Số mệnh đề

#lorem(loremAvg)

= Thực nghiệm và kết quả

== Mô hình bài toán PTSP về bài toán PESP

#lorem(loremAvg)

== Thu thập dữ liệu

#lorem(loremAvg)

== Kết quả và đánh giá

#lorem(loremAvg)

= Tổng kết

== Kết luận

#lorem(loremAvg)

== Kế hoạch và dự định

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
      [*Math*],
      [*SAT (direct)*],
    ),

    $
      pi = i, i in [0, T - 1],
      pi in ZZ, i in ZZ
    $,
    $ p_(i) = #true, p_(j) = #false forall j != i, 0 <= j < T $,

    $
      pi = i, i in [0, T - 1],
      pi in ZZ, i in ZZ
    $,
    $ (or.big_(i = 0)^(i < T) p_i) and (and.big_(i=0)^(i < T) and.big_(j = 0, j != i)^(j < T) p_i => not p_j) $,

    $
      pi = i, i in [0, T - 1],
      pi in ZZ, i in ZZ
    $,
    $ (or.big_(i = 0)^(i < T) p_i) and (and.big_(i=0)^(i < T) and.big_(j = 0, j != i)^(j < T) not p_i or not p_j) $,
  ),
  caption: "Table test",
)

#pagebreak()

#lorem(60)

#pagebreak()

#show heading.where(depth: 1): it => pad(text(it.body, size: 24pt), x: 0pt, y: 40pt)

#set heading(numbering: none)
#counter(heading).update(100)

#bibliography("citation.bib")