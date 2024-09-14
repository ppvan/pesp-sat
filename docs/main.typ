#import "@preview/acrotastic:0.1.1": *
#import "@preview/fletcher:0.5.1" as fletcher: diagram, node, edge
#import "@preview/cetz:0.2.1"


#import "@preview/ctheorems:1.1.2": *
#show: thmrules.with(qed-symbol: $square$)

#set page(width: 16cm, height: auto, margin: 1.5cm)
#set heading(numbering: "1.1.")

#let theorem = thmbox("theorem", "Theorem", fill: rgb("#eeffee"))
#let corollary = thmplain(
  "corollary",
  "Corollary",
  base: "theorem",
  titlefmt: strong,
)
#let definition = thmbox("definition", "Định nghĩa", inset: (x: 1.2em, top: 1em))

#let example = thmplain("example", "Ví dụ").with(numbering: "1.1")
#let proof = thmproof("proof", "Proof")


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

Lập kế hoạch cho hệ thống tàu điện ngầm là một công việc đầy khó khăn và thử thách, bao gồm nhiều giai đoạn khác nhau, như: nghiên cứu thị trường, thiết lập tuyến đường, thiết lập phương tiện, lập lịch tàu chạy và đào tạo nhân viên. Các giai đoạn lập kế hoạch này liên quan mật thiết đến nhau và thường được tiến hành đổ thác theo thứ tự. Tuy nhiên, có thể quay lại bước trước đó để tối ưu khi các yêu cầu nghiêm vụ được làm rõ hơn.


#figure(
  image("image/railway-steps.svg"),
  caption: "Các giai đoạn lập kế hoạch xây dựng hệ thống tàu điện ngầm",
)


+ *Nghiên cứu nhu cầu di chuyển*: Khảo sát thị trường và nhu cầu di chuyển của khách hàng nhằm thiết kế tuyến đường phù hợp

+ *Thiết lập tuyến đường*: Dựa trên nhu cầu di chuyển, ta thiết kế các tuyến đường nhằm đạt hiệu quả di chuyển cao nhất, quy trình này cần đảm bảo các chuyến tàu được kết nối với nhau và giảm thiểu số lần chuyển chuyến.

+ *Thiết lập phương tiện*: Dựa theo nhu cầu di chuyển và tuyến đường, ta cần lập danh sách các phương tiện (cần bao nhiêu phương tiện, sức chứa, tốc độ di chuyển...)

+ *Xây dựng lịch trình*: Khi biết rõ tuyến đường và công thông số phương tiện, ta có thể xây dựng lịch trình tàu chạy. Lịch trình cần đáp ứng các yêu chuẩn an toàn cũng như các yêu cầu về nghiệp vụ, và sẵn sàng cho các tình huống sự cố gián đoạn, hủy chuyến...

+ *Phân bổ nhân viên*: Tương tự, việc xây dựng lịch trình cho các nhân viên lái tàu, phục vụ, nhân viên sửa chữa, bảo hành cũng cần được quan tâm.

Trong đó, _xây dựng lịch trình_ là giai đoạn thiết yếu đối với hệ thống tàu điện ngầm. Việc cung cấp thời gian khởi hành và đến chính xác giúp lịch trình tàu hoạt động mượt mà và đáng tin cậy, đồng thời quản lý lưu lượng hành khách và ngăn ngừa tình trạng quá tải. Lịch trình hiệu quả cũng phối hợp các kết nối với các phương thức vận chuyển khác, cải thiện kế hoạch vận hành bằng cách lập kế hoạch bảo trì và phân bổ nhân sự, và tối ưu hóa việc sử dụng tài nguyên như tàu và đội ngũ. Tổng thể, lịch trình đáng tin cậy dẫn đến sự hài lòng cao hơn của khách hàng và một hệ thống giao thông công cộng trơn tru, hiệu quả hơn.

Tuy nhiên, lập lịch trình tàu hỏa là một nhiệm vụ vô cùng khó khăn và tốn kém, vì phải đáp ứng nhiều tiêu chí phức tạp. Trước hết, thời gian đệm (recovery times) cần được tính toán để bù đắp cho những gián đoạn trong hệ thống, như sự thay đổi tốc độ do thời tiết hoặc thiên tai, và tình trạng tàu khởi hành muộn so với dự kiến. Để tránh làm gián đoạn toàn bộ hệ thống, lịch trình phải bao gồm thời gian đệm phù hợp. Tiếp theo, thời gian giãn cách tối thiểu (minimum headway time) là cần thiết để đảm bảo an toàn khi hai tàu sử dụng chung một đường ray và phải khởi hành cách nhau một khoảng thời gian tối thiểu. Tính kết nối (connections between trains) cũng rất quan trọng, vì thời gian đến và khởi hành của các tàu tại cùng một bến đỗ cần phải liên tục để phục vụ nhu cầu nối chuyến của hành khách. Cuối cùng, thời gian bảo trì (turn around times at termination) phải được tính toán để bao gồm thời gian cần thiết cho việc bảo trì động cơ, tiếp nhiên liệu và thay ca nhân viên ở ga tàu cuối trước khi tàu quay trở lại.

Trước đây, xây dựng lịch trình tàu chạy chủ yếu được làm thủ công @cyc, tốn nhiều chi phí cũng như dễ xảy ra sai sót. Vì vậy, trong thập kỷ trước, nhiều nghiên cứu nhằm hỗ trợ và tự động quá trình lập lịch đã được tiến hành @liebchen2007modeling @odijk1996constraint @yan2019multi. Hầu hết các nghiên cứu đều dựa trên mô hình _lập lịch sự kiện định kỳ_ (Periodic Event Schedule Problem - PESP), một mô hình nổi tiếng được giới thiệu bởi Serafini and Ukovich @pesp-intro. Tuy nhiên, các phương pháp hiện tại trong việc giải bài toán PESP như lập trình ràng buộc, quy hoạch số nguyên chưa hiệu quả với các bộ dữ liệu lớn. Trong khóa luận này, chúng tôi trình bày phương pháp giải bài toán PESP sử dụng SAT Solver và đề xuất một vài cải tiến về thuật toán mã hóa.

Phần còn lại của khóa luận được tổ chức như sau:

- *Chương 1*: Định nghĩa chi tiết các khái niệm trong bài toán _lập lịch sự kiện định kỳ_, một số cách tiếp cận hiện tại

- *Chương 2*: Trình bày kiến nền tảng về logic mệnh đề và các khái niệm liên quan đến bài toán SAT như NP-complete, Satisfiablility Problem, SAT Solver và quy trình giải bài toán thực tế sử dụng SAT solver.

- *Chương 3*: Đề xuất thuật toán chuyển đổi bài toán PESP về bài toán SAT và cách giải cùng cải tiến thuật toán mã hóa.

- *Chương 4*: Thử nghiệm thực tế và kết luận

#pagebreak()


#set heading(numbering: "1.1.1")
#let loremAvg = 400
#counter(heading).update(0)
#counter(page).update(1)

#show heading.where(depth: 1): it => block(width: 100%)[
  #block(upper(text(weight: "light", size: 11.5pt, "Chương " + counter(heading).display())))
  #pad(block(text(it.body, size: 23pt)), y: 32pt, bottom: 36pt)
]

= Lập lịch sự kiện định kỳ <start>

== Định nghĩa bài toán

#definition[
  (Đoạn). Cho $a, b in ZZ $ với $a <= b.$

  $ [a, b] := {a, a + 1, a + 2, ...,b - 1, b} $

  được gọi là đoạn từ cận dưới $a$ đến cận trên $b$ hay đoạn từ $a$ đến $b$.
]


#definition[
  (Đoạn mô-đun). Cho $a, b in ZZ "and" t in NN^*$. Với $a$ là cận dưới và $b$ là cận trên,

  $ [a, b]_t := union.big_(z in ZZ) [a + z dot t, b + z dot t] $

  được gọi là _đoạn mô-đun_ $t$.
]

#example[
  Cho

  $
    I &= [3, 7]_8 \
    &= ... union [-13, -9] union [-5, -1] union [3, 7] union [11, 15] union [19, 23] ...
    subset Z \
  $

  là đoạn mô-đun 8. Khi đó

  $
    5 &in [3, 7] subset I \
    -10 &in [-13, -9] subset I \
    12 &in [11, 15] subset I
  $

  #figure(
    cetz.canvas({
      import cetz.draw: *

      let min = -12
      let max = 10
      let (a, b) = ((0, 0), ((max - min) / 1.5, 0))

      line(
        (rel: (-1, 0), to: a),
        (rel: (1, 0), to: b),
        mark: (fill: black, end: "stealth"),
        name: "line",
      )

      // Place labels

      let labels = (
        (-10, $-10$),
        (5, $5$),
      )


      let len = cetz.vector.dist(a, b)

      for (position, label) in labels {
        let pos = cetz.vector.lerp(a, b, (position - min) / (max - min))
        content(pos, label, anchor: "south", padding: (bottom: .50))
        group({
          set-origin(pos)
          scale(.1)
          line((0, 1), (0, 4), stroke: red, mark: (fill: red, start: ">"))
        })
      }

      // Place ticks

      let numbers = (3, 5, -10, 12, 7, -13, -9, 0, 11, 15)

      for maj in range(min, max + 1) {
        if maj in numbers {
          move-to(cetz.vector.lerp(a, b, (maj - min) / (max - min)))
          line((), (rel: (0, -.2)))
          content((rel: (0, -.1)), $maj$, anchor: "north")
        }
      }
    }),
    caption: "Minh họa đoạn mô-đun. -10 và 5 thuộc I",
  )
]


#definition[
  (Mạng sự kiện định kỳ). Một mạng sự kiện định kỳ (Periodic event network) chu kỳ $t_T$ $Nu = (nu, A, t_T)$ bao gồm tập hợp $nu$ sự kiện (danh sách đỉnh) và tập các ràng buộc $A$ (danh sách cạnh). Mỗi ràng buộc $a in A$ kết nối hai sự kiện, được kí hiệu:

  $
    a = ((i, j), [l_a, u_a]_t_T) in (nu times nu) times 2^ZZ
  $

  trong đó $l_a, u_a in ZZ$ lần lượt là cận trên và cận dưới, $2^ZZ$ là tập hợp các tập con của $ZZ$.

  Tập $A$ là hợp của hai tập hợp $S$ và $C$ lần lượt là tập ràng buộc đối xứng và ràng buộc thời gian.

  $
    S union C &= A \
    S sect C &= emptyset
  $
]

#example[
  Cho $N = ({A, B, C}, Nu, 8)$ là một mạng sự kiện định kỳ. Trong đó:

  $
    A = C = {
      &((A, B), [3, 7]_8),\
      &((B, C), [2, 4]_8),\
      &((A, C), [3, 5]_8)
    }
  $


  #figure(
    diagram(
      spacing: 10em,
      {
        let (a, b, c) = ((-1 / calc.sqrt(3), 0), (0, -1), (1 / calc.sqrt(3), 0))
        node(a, $A$, stroke: 1pt)
        node(b, $B$, stroke: 1pt)
        node(c, $C$, stroke: 1pt)
        edge(a, b, "->", $[3, 7]_8$)
        edge(b, c, "->", $[2, 4]_8$)
        edge(a, c, "->", $[3, 5]_8$)
      },
    ),
    caption: "Ví dụ minh họa mạng sự kiện định kỳ",
  )

] <example-1.1.2>

#definition[
  (Tiềm năng sự kiện). Cho $N = (nu, A, t_T)$ là một _mạng sự kiện định kỳ_. $pi_n in ZZ$ được gọi là tiềm năng xảy ra của sự kiện $n in nu$.

  Từ đây đến hết tài liệu, khái niệm này được gọi tắt là _tiềm năng_
]

#definition[
  (Lịch trình). Cho $N = (nu, A, t_T)$ là một _mạng sự kiện định kỳ_. Ánh xạ:

  $
    Pi_nu: &nu -> ZZ \
    &n |-> pi_n
  $
  được gọi là một lịch trình của tập sự kiện $N$
]


#definition[
  (Ràng buộc thời gian). Cho $N = (nu, A, t_T)$ là một _mạng sự kiện định kỳ_ với tập ràng buộc $A = S union C$ với ràng buộc $a = ((i, j), [l_a, u_a]_t_T) in C, i, j in nu$. Hai tiềm năng $pi_i$ và $pi_j$ thỏa mãn ràng buộc thời gian $a$ khi và chỉ khi:

  $
    pi_j - pi_i in [l_a, u_a]_t_T
  $
]


#definition[
  (Ràng buộc đối xứng). Cho $N = (nu, A, t_T)$ là một _mạng sự kiện định kỳ_ với tập ràng buộc $A = S union C$ với ràng buộc $a = ((i, j), [l_a, u_a]_t_T) in S, i, j in nu$. Hai tiềm năng $pi_i$ và $pi_j$ thỏa mãn ràng buộc đối xứng $a$ khi và chỉ khi:

  $
    pi_j + pi_i in [l_a, u_a]_t_T
  $
]

#example[
  Cho A, B là hai sự kiện và $a = ((A, B), \[3, 7\]_8)$ là _ràng buộc thời gian_.

  Các tiềm năng $(pi_a, pi_b) = (1, 5), (3, 2)$ thỏa mãn ràng buộc thời gian a vì:

  $
    5 - 1 &= 4 in [3, 7]_8 \
    2 - 3 &= -1 in [3, 7]_8
  $

  Ngược lại, tiềm năng $(pi_a, pi_b) = (3, 5), (7, 1)$ không thỏa mãn ràng buộc, vì:

  $
    5 - 3 &= 2 in.not [3, 7]_8 \
    1 - 7 &= -6 in.not [3, 7]_8
  $
]


#definition[
  Cho $N = (nu, A, t_T)$ là một _mạng sự kiện định kỳ_ và $Pi_nu$ là một lịch trình của $N$. Lịch trình $Pi$ thỏa mãn một ràng buộc $a in A$ khi và chỉ khi $pi_i = Pi_nu(i), pi_j = Pi_nu(j)$ thỏa mãn $a = (i, j, I)$
]

#definition[
  (Lịch trình hợp lệ) Cho $N = (nu, A, t_T)$ là một _mạng sự kiện định kỳ_ và $Pi_nu$ là một lịch trình của $N$. Lịch trình $Pi$ được xem là hợp lệ nếu thỏa mãn mọi ràng buộc $a in A$.
]

#example[
  Cho $N = (nu, A, 8)$ là mạng sự kiện định kỳ ở @example-1.1.2 và $Pi_nu$ là một lịch trình hợp lệ của $N$ với $pi_a = 6, pi_b = 1, pi_c = 3$. $Pi_nu$ là hợp lệ bởi vì:

  $
    pi_b - pi_a &= 1 - 6 = -5 in [3, 7]_8 \
    pi_c - pi_b &= 3 - 1 = 2 in [2, 4]_8 \
    pi_c - pi_a &= 3 - 6 = -3 in [3, 5]_8 \
  $

  được minh họa trong hình dưới đây:
  #figure(
  diagram(
    spacing: 10em,
    {
      let (a, b, c) = ((-1 / calc.sqrt(3), 0), (0, -1), (1 / calc.sqrt(3), 0))
      node(a, $pi_a = 6$, stroke: 1pt, shape: circle)
      node(b, $pi_b = 1$, stroke: 1pt, shape: circle)
      node(c, $pi_c = 3$, stroke: 1pt, shape: circle)
      edge(a, b, "->", $1 - 6 = -5 in [3, 7]_8 $)
      edge(b, c, "->", $3 - 1 = 2 in [2, 4]_8 $)
      edge(a, c, "->", $3 - 6 = -3 in [3, 5]_8$)
    },
  ),
  caption: "Ví dụ minh họa mạng lịch trình hợp lệ",
)
]


#definition[
  (Lịch trình tương đương) Cho $N = (nu, A, t_T)$ là một _mạng sự kiện định kỳ_ và $Pi_nu$ là một lịch trình của $N$. Lịch trình $Pi_nu$ và $Phi_nu$ được xem là tương đương:

  $
    Pi_nu equiv Phi_nu
  $

  khi và chỉ khi

  $
    forall n in nu: Pi_nu(n) mod t_T = Phi_nu(n) mod t_T
  $
]


#example[
  Cho $N = (nu, A, 8)$ là mạng sự kiện định kỳ ở @example-1.1.2 và $Pi_nu$ là một lịch trình hợp lệ của $N$ với $pi_a = 6, pi_b = 1, pi_c = 3$. $Pi_nu$ là hợp lệ bởi vì:

  $
    pi_b - pi_a &= 1 - 6 = -5 in [3, 7]_8 \
    pi_c - pi_b &= 3 - 1 = 2 in [2, 4]_8 \
    pi_c - pi_a &= 3 - 6 = -3 in [3, 5]_8 \
  $

  được minh họa trong hình dưới đây:
  #figure(
  diagram(
    spacing: 10em,
    {
      let (a, b, c) = ((-1 / calc.sqrt(3), 0), (0, -1), (1 / calc.sqrt(3), 0))
      node(a, $pi_a = 6$, stroke: 1pt, shape: circle)
      node(b, $pi_b = 1$, stroke: 1pt, shape: circle)
      node(c, $pi_c = 3$, stroke: 1pt, shape: circle)
      edge(a, b, "->", $1 - 6 = -5 in [3, 7]_8 $)
      edge(b, c, "->", $3 - 1 = 2 in [2, 4]_8 $)
      edge(a, c, "->", $3 - 6 = -3 in [3, 5]_8$)
    },
  ),
  caption: "Ví dụ minh họa mạng lịch trình hợp lệ",
)
]




== Phương pháp giải

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

#pagebreak()

#show heading.where(depth: 1): it => pad(text(it.body, size: 24pt), x: 0pt, y: 40pt)

#set heading(numbering: none)
#counter(heading).update(100)

#bibliography("citation.bib")