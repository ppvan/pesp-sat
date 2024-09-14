#import "@preview/acrotastic:0.1.1": *


#set page(paper: "a4", margin: (top: 2.5cm, bottom: 3cm, left: 2.5cm, right: 2cm), numbering: "1")

#set pagebreak(weak: true)

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


Hiện nay, hiệu năng của các SAT Solver đã cải thiện đáng kể và có thể được ứng dụng trong việc giải các bài toán NP-complete như: _Traveling Salesman, 
Hamiltonian path
, graph k-coloring..._. Vấn đề lập lịch sự kiện định kỳ (Periodic Event Scheduling Problem) từ lâu đã được chương minh là một vấn đề NP-complete. Các phương pháp hiện tại như lập trình ràng buộc (Constraint satisfaction Programing) hay quy hoạch số nguyên (Integer Programing) chưa thực sự hiệu quả với các bộ dữ liệu lớn.
Tài liệu này sẽ trình bày thuật toán chuyển hóa vấn đề lập lịch định kỳ (PESP) về bài toán SAT, sau đó giải bài toán sử dụng SAT Solver nhằm đạt được hiệu suất cao hơn.


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
  "", "Sinh viên",
  "", "Phạm Văn Phúc",
)


#pagebreak()

= Lời cam đoan

Em xin cam đoan khóa luận tốt nghiệp là của em, do em thực hiện dưới sự hướng
dẫn của TS. Tô Văn Khánh. Tất cả tham khảo, nghiên cứu
và tài liệu liên quan đều được nêu rõ ràng và chi tiết trong danh mục tài liệu tham khảo.
Các nội dung trình bày trong khóa luận này là hoàn toàn trung thực và không sao chép bất kỳ nguồn nào khác mà không trích dẫn.

#v(1em)

#let spaceTime = () => {

  datetime.today().display("Hà Nội, ngày [day] tháng [month] năm [year]")
}

#grid(
  columns: (1fr, auto),
  align: center,
  inset: 10pt,
  // gutter: 30pt,
  "", spaceTime(),
  "", "Sinh viên", "", pad("Phạm Văn Phúc", top: 40pt)
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

#init-acronyms((
  "SAT": ("Satisfiablility"),
  "UNSAT": "Unsatisfiability",
  "CNF": "Conjunctive Normal Form",
  "PTSP": "Periodic Train Timetable Scheduling Problem",
  "PESP": "Periodic Event Scheduling Problem",
  "CSP": "Contraint Satisfaction Problem",
  "MIP": "Mixed Integer Programing",
))

#{
  print-index(title: "Danh mục viết tắt", outlined: false, sorted: "up")
}


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


= Mở đầu

Lập kế hoạch cho hệ thống tàu điện ngầm là một công việc đầy khó khăn và thử thách, bao gồm nhiều giai đoạn khác nhau, như: nghiên cứu thị trường, thiết lập tuyến đường, thiết lập phương tiện, lập lịch tàu chạy và đào tạo nhân viên.


#figure(
  image("image/railway-steps.svg"),
  caption: "Các giai đoạn lập kế hoạch xây dựng hệ thống tàu điện ngầm"
)


+ *Nghiên cứu nhu cầu di chuyển*: Khảo sát thị trường và nhu cầu di chuyển của khách hàng nhằm thiết kế tuyến đường phù hợp

+ *Thiết lập tuyến đường*: Dựa trên nhu cầu di chuyển, ta thiết kế các tuyến đường nhằm đạt hiệu quả di chuyển cao nhất, quy trình này cần đảm bảo các chuyến tàu được kết nối với nhau và giảm thiểu số lần chuyển chuyến.

+ *Thiết lập phương tiện*: Dựa theo nhu cầu di chuyển và tuyến đường, ta cần lập danh sách các phương tiện (cần bao nhiêu phương tiện, sức chứa, tốc độ di chuyển...)

+ *Xây dựng lịch trình*: Khi biết rõ tuyến đường và công thông số phương tiện, ta có thể xây dựng lịch trình tàu chạy. Lịch trình cần đáp ứng các yêu chuẩn an toàn cũng như các yêu cầu về nghiệp vụ, và sẵn sàng cho các tình huống sự cố gián đoạn, hủy chuyến...

+ *Phân bổ nhân viên*: Tương tự, việc xây dựng lịch trình cho các nhân viên lái tàu, phục vụ, nhân viên sửa chữa, bảo hành cũng cần được quan tâm.

Các giai đoạn lập kế hoạch này liên quan mật thiết đến nhau và thường được tiến hành đổ thác theo thử tự. Tuy nhiên, có thể quay lại bước trước đó để tối ưu khi các yêu cầu nghiêm vụ được làm rõ hơn. Trong đó, khâu xây dựng lịch trình tàu là một công việc phức tạp, phải đáp ứng nhiều tiêu chí như:

+ *Thời gian đệm (recovery times)*: Thời gian đệm bù vào những gián đoạn trong hệ thống (vận tốc tàu không như tính toán do thời tiết, thiên tai, tàu khởi hành muộn so với dự kiến...). Để đảm bảo sự sai lệch này không làm tê liệt toàn bộ hệ thống, một lịch trình cần tính đến khoảng thời gian này.

+ *Thời gian giãn cách tối thiểu(minimum headway time)*: Nếu hai tàu dùng chung một đường ray, chúng phải khởi hành cách nhau 1 khoảng thời gian tối thiểu, vì lí do an toàn.

+ *Tính kết nối (Connections between trains)*: Thời gian đến/khởi hành của các tàu chung một bến đỗ nên liền mạch với nhau nhằm phục vụ nhu cầu đi nối chuyến của khách hàng.

+ *Thời gian bảo trì (Turn around times at termination)*: Thời gian bảo trì động cơ, nhiên liệu, thay ca nhân viên ở ga tàu cuối trước khi quay ngược lại.



Trước đây, xây dựng lịch trình tàu chạy chủ yếu được làm thủ công @cyc, tốn nhiều thời gian, công sức và tiền bạc. Vì vậy, trong thập kỷ trước, nhiều nghiên cứu nhằm hỗ trợ và tự động quá trình lập lịch đã được tiến hành @liebchen2007modeling @odijk1996constraint @yan2019multi. Hầu hết các nghiên cứu đều dựa trên mô hình _lập lịch sự kiện định kỳ_ (Periodic Event Schedule Problem - PESP), một mô hình nổi tiếng được giới thiệu bởi Serafini and Ukovich @pesp-intro.



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

== Vấn đề lập lịch sự kiện định kỳ (PESP)

=== Định nghĩa bài toán

=== Các giải pháp hiện tại

#lorem(loremAvg)

= Kiến thức nền tảng

== Logic mệnh đề
=== Mệnh đề

#lorem(loremAvg)

=== Các phép toán logic

#lorem(loremAvg)

=== Chuẩn tắc tuyển và chuẩn tắc hội

#lorem(loremAvg)

== SAT
=== Vấn đề 3-SAT

#lorem(loremAvg)

=== SAT Solver

#lorem(loremAvg)

=== SAT Encoding và ứng dụng

= Mô hình bài toán PESP về bài toán SAT

== Binominal Encoding

=== Mã hóa sự kiện

#lorem(loremAvg)

=== Mã hóa ràng buộc

#lorem(loremAvg)

== Order Encoding

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