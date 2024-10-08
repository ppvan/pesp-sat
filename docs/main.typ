#import "@preview/acrotastic:0.1.1": *
#import "@preview/fletcher:0.5.1" as fletcher: diagram, node, edge
#import "@preview/cetz:0.2.1"


#import "@preview/ctheorems:1.1.2": *
#show: thmrules.with(qed-symbol: $square$)

#set page(width: 16cm, height: auto, margin: 1.5cm)
#set heading(numbering: "1.1.", supplement: "Chương")

#show link: underline

#let theorem = thmbox("theorem", "Định lý", fill: rgb("#eeffee"))
#let corollary = thmplain(
  "corollary",
  "Hệ quả",
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

#show heading.where(depth: 2): it => block(width: 100%)[
  #pad(block(text(it, size: 16pt)), y: 16pt)
]

#show heading.where(depth: 3): it => block(width: 100%)[
  #pad(block(text(it, size: 14pt)), y: 4pt)
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
  let _page = counter(page).at(ch.location()).first()

  if ch.has("label") and ch.label == <intro_fig> {
    return it
  }

  v(16pt, weak: true)

  if 0 in num {
    strong(it.element.body + h(0.2em) + box(width: 1fr) + h(0.2em)) + numbering("i", _page)
  } else if 100 in num {
    strong(it.element.body + h(0.2em) + box(width: 1fr) + h(0.2em) + numbering("1", _page))
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
) <intro_fig>


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

#show heading.where(depth: 1): it => block(width: 100%)[
  #block(upper(text(weight: "light", size: 11.5pt, "Chương " + counter(heading).display())))
  #pad(block(text(it.body, size: 23pt)), y: 32pt, bottom: 36pt)
]
#counter(page).update(1)

= Lập lịch sự kiện định kỳ <start>

== Mạng sự kiện định kỳ

Chương 


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
        edge(a, b, "->", $1 - 6 = -5 in [3, 7]_8$)
        edge(b, c, "->", $3 - 1 = 2 in [2, 4]_8$)
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
        edge(a, b, "->", $1 - 6 = -5 in [3, 7]_8$)
        edge(b, c, "->", $3 - 1 = 2 in [2, 4]_8$)
        edge(a, c, "->", $3 - 6 = -3 in [3, 5]_8$)
      },
    ),
    caption: "Ví dụ minh họa mạng lịch trình hợp lệ",
  )
]

#theorem[
  (Tính hợp lệ của lịch trình tương đương). Cho $N = (nu, A, t_T)$ là một mạng sự kiện định kỳ, $Pi_nu, Phi_nu$ là hai lịch trình tương đương. Khi đó, với tập ràng buộc $A$:

  $
    Pi_nu "hợp lệ" <=> Phi_nu "hợp lệ"
  $
]

#proof[
  #set math.equation(numbering: "(1)")
  Không mất tính tổng quát, chỉ cần chứng minh $Pi_nu "hợp lệ" => Phi_nu "hợp lệ"$.

  Ta có: $Pi_nu$ hợp lệ với tập ràng buộc $A$ $=> forall a in A:$

  $
    Pi_nu "thỏa mãn" a
  $ <st>

  Thật vậy, với $A = C union S$, cần chứng minh:

  $
    forall a in C&: Phi_nu "thỏa mãn" a
  $ <prof1>

  $
    forall a in S&: Phi_nu "thỏa mãn" a
  $ <prof2>


  Giả sử $a = ((i, j), [l_a, u_a]_t_T) in C$ là một ràng buộc thời gian bất kỳ.

  với $i, j in nu, pi_i = Pi_(nu)(i), pi_j = Pi_(nu)(j), phi_i = Phi_(nu)(i), phi_j = Phi_(nu)(j)$

  $
    (1) &=> pi_j - pi_i in [l_a, u_a]_t_T\
    &=> pi_j - pi_i in {[l_a + z dot t_T, u_a + z dot t_T] | z in ZZ}\
    &=> forall w, v in ZZ: pi_j - pi_i + w dot t_T - v dot t_T in {[l_a + z dot t_T, u_a + z dot t_T] | z in ZZ}\
    &=> forall w, v in ZZ: (pi_j + w dot t_T) - (pi_i + v dot t_T) in {[l_a + z dot t_T, u_a + z dot t_T] | z in ZZ}\
    &=> (pi_j mod t_T) - (pi_i mod t_T) in {[l_a + z dot t_T, u_a + z dot t_T] | z in ZZ}\
    &=> (pi_j mod t_T) - (pi_i mod t_T) in [l_a, u_a]_t_T\
    &=> (phi_j mod t_T) - (phi_i mod t_T) in [l_a, u_a]_t_T\
    &=> phi_j - phi_i in [l_a, u_a]_t_T\
    &=> Phi_nu "thỏa mãn" a
  $

  Tương tự, ra chứng minh được @prof2
]

#corollary[
  Cho $[Pi_nu]_equiv := {Phi_nu | Phi_nu equiv Pi_nu}$, $Pi_nu$ hợp lệ. Khi đó:
  $
    forall Phi_nu in [Pi_nu]_equiv => Phi_nu "hợp lệ"
  $
]


#corollary[
  Cho $[Pi_nu]_equiv := {Phi_nu | Phi_nu equiv Pi_nu}$, $Pi_nu$ hợp lệ. Khi đó tồn tại một lịch trình $Phi_nu in [Pi_nu]_equiv$ sao cho:
  $
    forall n in nu: Phi_(nu)(n) in [0, t_T - 1]
  $
] <cor1>

@cor1 là hệ quả quan trọng, giới hạn miền nghiệm của lịch trình trở thành hữu hạn. Vì vậy, khi tìm kiếm lịch trình hợp lệ, ta chỉ cần tìm các tiềm năng trong đoạn $[0, t_T-1]$. Nếu không tồn tại hệ quả này, ta không thể giải bài toán PESP với logic mệnh đề vì không gian tìm kiếm là vô hạn.


== Bài toán lập lịch sự kiện định kỳ

#definition[
  (PESP). Cho $N = (nu, A, t_T)$ là một _mạng sự kiện định kỳ_, bài toán đặt ra câu hỏi: _Liệu có tồn tại một lịch trình hợp lệ thỏa mãn mạng trên?_
] <pesp_def>

Dễ thấy, PESP là một vấn đề quyết định@kozen2012automata. Từ minh họa @example-1.1.2, dễ hình dung PESP có thể chuyển thành bài toán _Vertex Coloring_, vậy PESP là bài toán NP-complete, được chứng minh bằng cách chuyển về bài toán _Vertex Coloring_ @odijk1994construction.

#pagebreak()

= Kiến thức nền tảng

== Logic mệnh đề
=== Mệnh đề


#definition[
  (Mệnh đề): Mệnh đề là một nhận định đúng hoặc sai.
  Kí hiệu: $x, y, z, A, B, C...$
]



#example[
  Các nhận định sau là mệnh đề:
  - A = "Hôm nay trời mưa"
  - B = "2 là số nguyên tố"
  - z = "10 lớn hơn 20"
  trong khi các nhận định sau không phải mệnh đề do không có tính đúng sai rõ ràng:
  - Lan bao nhiêu tuổi?
  - Dọn nhà đi!
] <logic_ex>

#definition[
  (Chân trị) Một mệnh đề có thể đúng hoặc sai. Tính đúng sai của mệnh đề được gọi là chân trị của mệnh đề. Mệnh đề đúng có chân trị là 1 (`true`), mệnh đề sai có chân trị 0 (`false`).
]

#example[

  Theo @logic_ex, $A, B$ là mệnh đề đúng, $z$ là mệnh đề sai:
]

=== Các phép toán logic

Tương tự với số học, ta cũng có phép toán giữa các mệnh đề. Sau đây giới thiệu một số phép toán cơ bản thường dùng.

#definition[
  (Phủ định): Mệnh đề phủ định của mệnh đề $a$ là mệnh đề có chân trị đối lập với $a$.\
  _Kí hiệu_: $not a$.

  #figure(
    table(
      align: center + horizon,
      columns: (4em, 4em),
      [*$a$*], [*$not a$*],
      "0", "1",
      "1", "0",
    ),
    caption: "Bảng chân trị của phép phủ định",
  ) <logic_not>
]

#example[
  $
    A &= "\"Hôm nay trời mưa\""\
    => not A &= "\"Hôm nay trời không mưa"\"
  $
]


#definition[
  (Phép hội): Mệnh đề hội của hai mệnh đề $a, b$ là mệnh đề chỉ đúng khi cả $a, b$ đều đúng. \
  _Kí hiệu_: $a and b$

  #figure(
    table(
      align: center + horizon,
      columns: (4em, 4em, 4em),
      [*$a$*], [*$b$*], [*$a and b$*],
      "0", "0", "0",
      "1", "0", "0",
      "0", "1", "0",
      "1", "1", "1",
    ),
    caption: "Bảng chân trị của phép hội",
  ) <logic_and>
]


#definition[
  (Phép tuyển): Mệnh đề tuyển của hai mệnh đề $a, b$ là mệnh đề chỉ sai khi cả $a, b$ đều sai. \
  _Kí hiệu_: $a or b$

  #figure(
    table(
      align: center + horizon,
      columns: (4em, 4em, 4em),
      [*$a$*], [*$b$*], [*$a or b$*],
      "0", "0", "0",
      "1", "0", "1",
      "0", "1", "1",
      "1", "1", "1",
    ),
    caption: "Bảng chân trị của phép tuyển",
  ) <logic_or>
]


#definition[
  (Phép kéo theo): Mệnh đề kéo của hai mệnh đề $a, b$ là mệnh đề chỉ sai khi cả $a$ đúng $b$ sai. \
  _Kí hiệu_: $a => b$

  #figure(
    table(
      align: center + horizon,
      columns: (4em, 4em, 4em),
      [*$a$*], [*$b$*], [*$a => b$*],
      "0", "0", "1",
      "1", "0", "0",
      "0", "1", "1",
      "1", "1", "1",
    ),
    caption: "Bảng chân trị của phép kéo theo",
  )
]




#definition[
  (Phép tương đương): Mệnh đề tương của hai mệnh đề $a, b$ là mệnh đề chỉ đúng khi cả $a$ và $b$ cùng đúng hoặc cùng sai. \
  _Kí hiệu_: $a <=> b$

  #figure(
    table(
      align: center + horizon,
      columns: (4em, 4em, 4em),
      [*$a$*], [*$b$*], [*$a <=> b$*],
      "0", "0", "1",
      "1", "0", "0",
      "0", "1", "0",
      "1", "1", "1",
    ),
    caption: "Bảng chân trị của phép tương đương",
  )
]

=== Biểu thức logic



#definition[
  (Mệnh đề sơ cấp): Mệnh đề sơ cấp (literal) là chỉ bao gồm mệnh đề và phủ định của nó ($a "và" not a$). Mệnh đề sơ cấp không thể chia thành các mệnh đề nhỏ hơn.
]


#definition[
  (Biểu thức logic): Biểu thức logic được định nghĩa đệ quy như sau:
  1. Mỗi mệnh đề sơ cấp là một biểu thức ($A, not B, C, x, y, z...$)
  2. Nếu $A, B$ là hai biểu thức thì $A and B, A or B, A => B, A <=> B$ cũng là các biểu thức.
]


#example[
  Các biểu thức logic:
  $
    f(x, y, z) &= (x or y) and z \
    g(a, b) &= a => not b
  $
]



#definition[
  (Bảng chân trị): Bảng chân trị là bảng tính toán chân trị của biểu thức logic theo từng giá trị của các biến tham gia trong biểu thức.

  @logic_not, @logic_and, @logic_or là ví dụ các bảng chân trị.
]



#definition[
  (Biểu thức tương đương): Nếu hai biểu thức $f, g$ có cùng bảng chân trị thì $f, g$ được gọi là biểu thức tương đương.
  _Kí hiệu:_

  $
    f <=> g
  $
]

#example[
  Theo định nghĩa, ta có: $a => b <=> not a or b$
  #figure(
    table(
      align: center + horizon,
      columns: (4em, 4em, 4em, 4em),
      [*$a$*], [*$b$*], [*$a => b$*], [$not a or b$],
      "0", "0", "1", "1",
      "1", "0", "0", "0",
      "0", "1", "0", "0",
      "1", "1", "1", "1",
    ),
    caption: "Bảng chân trị của hai biểu thức tương đương",
  )
]



=== Chuẩn tắc tuyển và chuẩn tắc hội


#definition[
  (Tuyển sơ cấp): Tuyển của các mệnh đề sơ cấp được gọi là tuyển sơ cấp.
]

#definition[
  (Hội sơ cấp): Hội của các mệnh đề sơ cấp được gọi là hội sơ cấp.
]

#example[
  - Các tuyển sơ cấp: $a or not b or c or not d, x or y, y or not z$

  - Các hội sơ cấp: $a and not b and c and not d, x and y, y and not z$
]

#definition[
  (Chuẩn tắc tuyển): Tuyển của các hội sơ cấp được gọi là chuẩn tắc tuyển.

]


#example[
  $
    f = (x_1 and x_2 and not x_3) or (not x_1 and x_2 and not x_3)
  $
]

#definition[
  (Chuẩn tắc hội): Hội của các tuyển sơ cấp được gọi là chuẩn tắc hội (CNF). Chuẩn tắc hội có thường có dạng:
  $
    f = &(P_1 or P_2 or P_3 or ... or P_n)_1 and ... and (Q_1 or Q_2 or ... or Q_n)_p \
    &n, m, p in NN^*
  $

]


#example[
  $
    g = (x_1 or x_2 or not x_3) and (not x_1 or x_2 or not x_3)
  $
]

#theorem[
  Mọi biểu thức logic đều có dạng chuẩn tắc hội và chuẩn tắc tuyển tương ứng @cnfproof.
]

// FIXME: xem xét chứng minh lại luôn

#example[
  Cho biểu thức logic:

  $
    f &= ((p => q) and (r or not s)) => (t <=> (u or v))
  $

  Ta có thể chuyển nó về dạng CNF như sau:

  $f &= ((p => q) and (r or not s)) => (t <=> (u or v))\
    &= ((not p or q) and (r or not s)) => (t and (u or v) or (not t and not(u or v))) \
    &= not((not p or q) and (r or not s)) or (t and (u or v) or (not t and not(u or v))) \
    &= (p and not q) or (not r and s) or (t and (u or v) or (not t and (not u and not v))) \
    &= ((p and not q) or (not r and s) or t) and ((p and not q) or (not r and s) or u or v) \ &
    and ((p and not q) or (not r and s) or not t) \ &
    and ((p and not q) or (not r and s) or not t or not u) \ &
    and ((p and not q) or (not r and s) or not t or not v) \
    &= (p or not r or t or u or v) \ &
    and (p or s or t or u or v)
    and (not q or not r or t or u or v) \ &
    and (not q or s or t or u or v)
    and (p or not r or u or v) \ &
    and (p or s or u or v)
    and (not q or not r or u or v) \ &
    and (not q or s or u or v)
    and (p or not r or not t) \ &
    and (p or s or not t)
    and (not q or not r or not t) \ &
    and (not q or s or not t)
    and (p or not r or not t or not u) \ &
    and (p or s or not t or not u)
    and (not q or not r or not t or not u) \ &
    and (not q or s or not t or not u)
    and (p or not r or not t or not v) \ &
    and (p or s or not t or not v)
    and (not q or not r or not t or not v) \ &
    and (not q or s or not t or not v)$
]

Tương tự với dạng DNF, ta có biểu thức cuối cùng như sau:

$
  f = &(not p and r and t and u) or (not p and r and t and v) \
  &or (not p and not s and t and u) or (not p and not s and t and v) \
  &or (q and r and t and u) or (q and r and t and v) \
  &or (q and not s and t and u) or (q and not s and t and v) \
  &or (p and not q and not r and not t) or (p and not q and s and not t) \
  &or (p and not q and not r and not u and not v) or (p and not q and s and not u and not v)
$

== SAT

Nhằm cung cấp nền tảng kiến thức, sau đây khóa luận sẽ trình bày chi tiết các khái niệm liên quan đến logic mệnh đề nói chung và bài toán SAT. Đây là cơ sở quan trọng cho  @pesp_reduction

=== Vấn đề SAT

#definition[
  (Suy diễn - Interpretation) Cho $f in Sigma_("SAT")$ là một biểu thức logic mệnh đề, khi đó ánh xạ:
  $
    I: Sigma_("SAT") &-> {"true", "false"} \
    f^I &= w
  $
  được gọi là một suy diễn $I$ với giá trị $w$ của $f$
]

#example[
  Cho $f(x, y, z) = x and (y or z)$. Với suy diễn $I = {x: "true", y: "true", z: "false"}$ ta có:

  $
    f("true", "true", "false") = "true" and ("true" or "false") = "true"
  $
  hay
  $
    f^I (x,y,z) = "true"
  $
]


#definition[
  Cho $f in Sigma_("SAT")$ là một biểu thức logic mệnh đề, khi đó ánh xạ:
  $
    I: Sigma_("SAT") &-> {"true", "false"} \
    f^I &= w
  $
  được gọi là một suy diễn $I$ với giá trị $w$ của $f$
]


#definition[
  (Khả thỏa - Satisfiability) Cho $f in Sigma_("SAT")$ là một biểu thức logic mệnh đề, khi đó $f$ được gọi là khả thỏa hay SAT nếu tồn tại một suy diễn $I$:
  $
    f^I &= "true"
  $

  và $f$ không thể thỏa mãn, còn gọi là UNSAT nếu:
  $
    f^I &= "false" forall I
  $
]


#definition[
  (SAT). Cho $f in Sigma_("SAT")$ là một biểu thức logic mệnh đề ở dạng chuẩn tắc hội (CNF). _Liệu có tồn tại một suy diễn $I$ sao cho:_

  $
    f^I &= "true"
  $

  được gọi là bài toán Satisfiability hay bài toán SAT.
]


#example[
  Ví dụ về biểu thức SAT

  Cho $f = (x or y) and not z$. Ta thấy tồn tại một suy diễn $I = {x: "true", y: "false", z: "false"}$ mà $f^I = "true"$.
]

#example[
  Ví dụ về biểu thức UNSAT
  
  Cho $g = (x or y) and (not x or y) and (x or not y) and (not x or not y)$, không tồn tại suy diễn nào để $g^I = "true"$.

   #figure(
    table(
      align: center + horizon,
      columns: (4em, 4em, 4em),
      [*$x$*], [*$y$*], [*$g$*],
      "0", "0", "0",
      "1", "0", "0",
      "0", "1", "0",
      "1", "1", "0",
    ),
    caption: "Bảng chân trị của biểu thức UNSAT",
  )

]


=== SAT Solver

Bài toán SAT là bài toán thuộc lớp NP xuất hiện sớm nhất, đồng thời là bài toán đầu tiên được chứng minh là NP-complete @sat_np. Vì vậy, không tồn tại giải thuật tối ưu giải bài toán SAT có độ phức tạp đa thức. Tuy nhiên, nhiều nghiên cứu đã được tiến hành nhằm xây dựng chương trình giải bài toán SAT, thường gọi là các SAT Solver. Đầu vào chương trình thường là biểu thức logic dạng chuẩn tắc hội (CNF). Nếu biểu thức thỏa mãn được, đưa ra kết luận SAT và một nghiệm bất kỳ kèm chứng minh. Nếu không tồn tại nghiệm thoả mãn, kết luận UNSAT.

#figure(
  diagram(
    spacing: 5em,
    node-corner-radius: 4pt,
    {
      let (input, solver, sat, unsat) = ((-1, 0), (0, 0), (1, 1), (1, -1))

      node(input, [CNF formula \ $(x_1 or x_2 ...) and ... and (z_1 or z_2 ...)$ ], stroke: 1pt)
      node(solver, "SAT Solver", stroke: 1pt, inset: 1em)
      node(sat, [SAT+Solution+Proof], stroke: 1pt)
      node(unsat, "UNSAT", stroke: 1pt)

      edge(input, solver, "->")
      edge(solver, sat, "->")
      edge(solver, unsat, "->")

    },
  ),
  caption: "Sơ đồ đầu vào/đầu ra của SAT Solver",
)

Nhiều kĩ thuật đã được nghiên cứu nhằm cải thiện độ hiệu quả các SAT Solver theo thời gian, tiêu biểu như:

1. Thuật toán David-Putnam(1960)@putnam: Giảm số biến bằng thuật toán luận giải (resolusion).

2. Thuật toán Davis-Putnam-Logemann-Loveland (DPLL)@DPLL: Cải thiện thuật toán David-Putnam sử dụng kĩ thuật quay lui và nổi bọt đơn vị(unit propagation).

3. Conflict-Driven Clause Learning@cdcl: Mở rộng thuật toán DPLL, tối ưu giải thuật quay lui. Khi gặp một cặp mệnh đề mâu thuẫn và cần quay lui, thuật toán sẽ phân tích sai lầm này để tránh lặp lại tương tự. Thêm vào đó, thuật toán có thể quay lại trực tiếp điểm gây mâu thuẫn, giảm phần lớn nhánh cần tìm kiếm.

4. Những cải tiến khác về cơ sở dữ liệu, tiền xử lý, tận dụng khả năng xử lý song song @balyo2015hordesatmassivelyparallelportfolio@martins2012overview@hamadi2010manysat.

Do vậy, các SAT Solver hiện nay đã có khả năng giải các bài toán cực kì phức tạp, với hàng triệu biến và mệnh đề. Hằng năm, các cuộc thi về SAT Solver được tổ chức nhằm cải thiện hiệu suất thuật toán, tiêu biểu như #link("https://satcompetition.github.io/2024/", "SAT competition"). Phần lớn những người tham gia công bố SAT Solver dưới dạng thử viện mã nguồn mở, có thể dễ dàng tích hợp và sử dung. Sau đây liệt kê một số Solver có ảnh hưởng quan trọng trong lịch sử phát triển của các SAT Solver:

- *CaDiCal*: CaDiCal là bộ giải SAT dựa trên thuật toán CDCL Mục tiêu chính của CaDiCal không phải hiệu năng, mà là một cơ sở thuật toán dễ hiểu và mở rộng. Vì vậy đặt nền móng cho nhiều SAT Solver khác sau này.

- *Kissat*: Dựa trên CaDiCal, nhưng được viết lại bằng C, với nhiều cải tiến về cấu trúc dữ liệu, xếp lịch tiến trình xử lý, tối ưu hóa cài đặt thuật toán. Xếp hạng đầu trong hạng mục các công cụ giải SAT tuần tự trong cuộc thi giải SAT quốc tế năm 2022.
- *MiniSAT*: Một SAT Solver hiện đại, trở thành tiêu chuẩn trong công nghiệp. Dựa trên thuật toán CDCL, và giành chiến thắng trong cuộc thi giải SAT quốc tế năm 2005. Đây vẫn là một trong những SAT Solver được sử dụng nhiều nhất do chất lượng mã nguồn cao, rõ ràng và dễ cải tiến.

- *Glucose*: SAT Solver được dựa trên MiniSAT, áp dụng thêm nhiều kỹ thuật mới như phương pháp học mệnh đề hiện đại và giải song song.

- *Gini*: Một solver hiện đại được viết bằng Go, điểm đặc biệt của solver này là giao thức chia sẻ tính toán, cho phép giải song song sử dụng các goroutine. Đây cũng là solver được chọn để giải bài toán PESP khi thực nghiệm.

Để giải các bài toán thực tế sử dụng SAT Solver, ta cần định nghĩa hình thức các yêu cầu nghiệp vụ của bài toán thành các logic mệnh đề, giải bài toán SAT, sau đó suy luận kết quả từ đầu ra của SAT Solver. Sơ đồ có thể giải một bài toán sử dụng SAT Solver được minh họa trong @fig_1. Thuật toán encoding và decoding là một quá trình phức tạp, chương tiếp theo sẽ minh họa rõ hơn quá trình này.

#figure(
  diagram(
    spacing: 2em,
    node-stroke: 1pt,
    node-inset: 8pt,
    node-corner-radius: 4pt,
    {
      let (input, encoding, solver, desiion, decoding) = ((-1, 1), (0, 1), (0, 2), (1, 2), (2, 2))

      let (unsat, sat) = ((0, 5), (0, 3))
      let result = (3, 2)
      // set node(stroke: 1pt)

      node(input, "Input")
      node(encoding, "Encoding Module")
      node(solver, "SAT Solver", shape: fletcher.shapes.diamond, inset: 8pt)
      node(decoding, "Decoding Module")
      node(unsat, "No result")
      node(result, "Output")

      edge(input, encoding, "->")
      edge(encoding, solver, "->")
      edge(solver, decoding, "->", [SAT])
      edge(input, encoding, "->")
      edge(solver, unsat, "->", [UNSAT])
      edge(decoding, result, "->")
    },
  ),
  caption: "Sơ đồ giải bài toán thực tế sử dụng SAT Solver",
) <fig_1>


FIXME: có thể ví dụ thêm về 1 giải 1 bài toán đơn giản giải bằng SAT hoặc move phần giới thiệu encoding lên trên này.

#pagebreak(weak: true)
= Mô hình bài toán PESP về bài toán SAT <pesp_reduction>

== Sơ đồ tổng quan


#figure(
  diagram(
    spacing: 2em,
    node-stroke: 1pt,
    node-inset: 8pt,
    node-corner-radius: 4pt,
    {
      let (input, encoding, solver, desiion, decoding) = ((-1, 1), (0, 1), (0, 2), (1, 2), (2, 2))

      let (unsat, sat) = ((0, 5), (0, 3))
      let result = (3, 2)
      let verification = (2, 3)
      let encoding_cons = (2, 1)

      let direct_encode
      // set node(stroke: 1pt)

      node(input, [$N = (nu, A, t_T)$])
      node(encoding, "Encoding Potentials")
      node(encoding_cons, "Exclude unfeasible pairs")
      node(solver, "Gini SAT Solver", shape: fletcher.shapes.diamond, inset: 8pt)
      node(decoding, "Decoding Module")
      node(unsat, "No result")
      node(result, "Output")
      node(verification, "Verification")

      edge(input, encoding, "->")
      edge(encoding, encoding_cons, "->")
      edge(encoding_cons, solver, "->")
      edge(solver, decoding, "->", [SAT])
      edge(input, encoding, "->")
      edge(solver, unsat, "->", [UNSAT])
      edge(decoding, result, "->")
      edge(result, verification, "->")
    },
  ),
  caption: "Sơ đồ tổng quan giải bài toán PESP sử dụng SAT Solver",
)

Nhiều nghiên cứu liên quan đề xuất hai phương pháp mã hóa bài toán lập lịch định kỳ (PESP) về bài toán SAT là Binominal Encoding và Order Encoding.

Nhắc lại @pesp_def về PESP và @cor1 về không gian nghiệm, từ đây trở đi trong khóa luận này, ta định nghĩa lại bài toán PESP như sau:

#definition[
  Cho mạng định kỳ $N = (nu, A, t_T)$ gồm $n$ sự kiện, tập ràng buộc $A$ và chu kỳ T. Tìm n tiềm năng sự kiện $pi_1, pi_2, ..., pi_n$ trong đoạn $[0, t_T - 1]$ thỏa mãn tập ràng buộc $A$.
]

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


#pagebreak(weak: true)

= Thực nghiệm và kết quả

== Mô hình bài toán PTSP về bài toán PESP

Vấn đề lập lịch tàu chạy (PTSP) trong thực tế còn phức tạp và có nhiều yếu tố tác động. Tuy nhiên, với sai số cho phép, ta có thể chuyển hoá các yêu cầu nghiệp vụ về sự kiện và các ràng buộc trong bài toán PESP.

Ứng với mỗi tàu L và ga $s$, tạo một sự kiện khởi hành và cập bến $L_(t, s) (t in {"dep", "arr"})$. Mỗi sự kiện khởi hành và cập bến phải tuân theo chu kì $t_T$. Giữa hai sự kiện này có một ràng buộc thời gian $(L_("arr", s), L_("dep", s), [l, u]_t_T)$, ràng buộc thời gian tối thiểu và tối đa tàu dừng tại ga $("arrival" -> "departure")$. Tương tự, ta ràng buộc thời gian đi từ gia $s_1 -> s_2$ bằng ràng buộc $(L_("dep", s_1), L_("arr", s_2), [l', u']_t_T)$. $l', u'$ có thể ước lượng từ khoảng cách hai ga và vận tốc của tàu.

Để ngăn hai tàu sử dụng cùng một đường ray, ta giới hạn thời gian đến cùng 1 ga phải cách nhau một thời gian đệm tương đối: $(L_("arr", s), J_("arr", s), [l, u]_t_T)$. Tương tự với các yêu cầu ràng buộc khác.

Ta thu được thời gian biểu chính xác khi giải được bài toán PESP tương ứng.


== Thu thập dữ liệu

Dữ liệu thử nghiệm được thu thập từ #link("https://timpasslib.aalto.fi/pesplib.html", "PESPlib") @pesplib, một tập dữ liệu PESP đã được chuẩn hóa và xử lý nhằm đánh giá hiệu quả của các thuật toán giải PESP. PESPlib được cộng đồng học thuật đánh giá cao và được dùng làm tiêu chuẩn đánh giá trong nhiều nghiên cứu.@pesplib_ref_1 @pesplib_ref_2. 
Dữ liệu đầu vào gồm các file csv, có định dạng sau:


```csv
N; O; T; L; U; W
```
- N số thứ tự ràng buộc
- O sự kiện bắt đầu
- T sự kiện kết thúc
- L cận dưới của thời gian chuyển sự kiện
- U cận trên của thời gian chuyển sự kiện
- W là hệ số (độ quan trọng) của ràng buộc này

Lời giải của bài toán nên có định dạng sau:

```csv
N; D
```

- N là số thứ tự của sự kiện
- D là thời điểm sự kiện xảy ra

#example[
\
Input:\
1; 1; 2; 50; 55; 10\
2; 2; 3; 40; 50; 20\
3; 1; 3; 30; 40; 15\
\
Output:\
1; 50\
2; 40\
3; 30\
]

Toàn bộ dữ liệu đầu vào gồm 18 file với độ khó tăng dần, định dạng như mô tả ở trên. Thông qua tiền sử lý sơ bộ, ta có thông tin cơ bản của dữ liệu đầu vào như sau:

#let results = csv("image/input_instances.csv")

#figure(
  table(
    columns: (1fr, 1fr, 1fr, 1fr),
    ..results.flatten(),
  ),
  caption: "Bảng mô tả độ phức tạp của dữ liệu PESP đầu vào",
)


== Kết quả và đánh giá


Để tiến hành thử nghiệm hai phương pháp đã nêu ở @pesp_reduction, khoá luận đã cài đặt một công cụ dòng lệnh giải bài toán PESP có tên là #link("https://github.com/ppvan/pesp-sat", "pesp-sat"). 

Chương trình thử nghiệm được cài đặt bằng ngôn ngữ Go, sử dụng SAT Solver #link("https://github.com/go-air/gini", "Gini"). Công cụ hỗ trợ đa nền tảng, được kiểm thử kĩ lưỡng, độ bao phủ đạt 80%, mã nguồn lưu tại: #link("https://github.com/ppvan/pesp-sat", "ppvan/pesp-sat"). Tất cả tài liệu và dữ liệu liên quan, bao gồm mã nguồn công cụ thử nghiệm, tài liệu khóa luận và slide trình bày khóa luận được lưu trữ tại git repo này. 

Để kiểm chứng chương trình thử nghiệm, vui lòng làm theo hướng dẫn trong README.md. Thực nghiệm sau đây được tiến hành trên máy tính (laptop) sau:

#figure(
  table(
    columns: (auto, 12em),
    [*Component*], [*Details*],
    [CPU], [AMD Ryzen™ 7 7735H],
    [RAM], [32GB DDR4],
    [Disk], [512GB SSD NVme],
    [OS], [Linux 6.6.51-1-lts],
    [Gini(SAT Solver)], [v1.0.4 - Go 1.23],
  ),
  caption: "Cấu hình máy chạy thực nghiệm",
)


Khóa luận sẽ tiến hành đo thời gian chạy (ms), số mệnh đề, số biến của hai thuật toán mã hóa trình bày ở @pesp_reduction, chi tiết trong @benmark_1. Mỗi ví dụ đều được tính trung bình 10 lần chạy để giảm sai số.

#let benmark = csv("image/benmark.csv")

#figure(
  table(
    columns: 9,
    table.header([], [], [], table.cell([*Binominal*], colspan: 3), table.cell([*Order*], colspan: 3)),
    [Index], [Events], [Cons], [Vars], [Clauses], [Time], [Vars], [Clauses], [Time],
    ..benmark.flatten(),
  ),
  caption: "Kết quả chạy thử nghiệm, thời gian tính bằng mili giây (ms)",
  placement: top
) <benmark_1>

#figure(image("image/chart-vars.svg"), caption:"Biểu đồ đường so sánh số biến của Binominal và Order Encoding")


#figure(image("image/chart-clause.svg"), caption:"Biểu đồ đường so sánh số mệnh đề của Binominal và Order Encoding")


#figure(image("image/chart-time.svg"), caption:"Biểu đồ đường so sánh thời gian thực thi của Binominal và Order Encoding")

Quan sát bảng dữ liệu và các biểu đồ trên, ta thấy cả hai thuật toán đều tăng độ phức tạp nhất quán với độ phức tạp tăng dần của vấn đề PESP đầu vào. Khoảng cách giữa Binominal và Order Encoding là khá rõ rệt (khoảng 7x-50x về thời gian, 15x-20x về số mệnh đề). Tuy nhiên về số biến, hai phương pháp tương đối đồng đều. Như vậy, phương pháp mã hóa Order tỏ ra tương đối ưu việt so với Binominal, điều này có thể dễ dàng giải thích bởi Order encoding loại bỏ không gian tìm kiếm theo từng vùng thay vì từng điểm như Binominal, dẫn đến số mệnh đề ít hơn. Hơn nữa, theo mô tả ở @pesp_reduction, các mệnh đề Order encoding chồng chéo lên nhau kiến vùng mâu thuẫn được tìm ra nhanh chóng bởi SAT Solver.

Với sức mạnh phần cứng hiện tại, cả hai phương pháp đều giải ra khá nhanh (từ 100ms đến 24s) dù số mệnh đề lên đến hàng chục triệu, do giới hạn của dữ liệu đầu vào, ta chưa thống kê được giới hạn của hai giải thuật. Mặt khác, bài toán PESP sinh ra khá nhiều nghiệm thỏa mãn, dẫn đến nhu cầu tìm ra nghiệm tối ưu (bài toán lập lịch tàu chạy tối ưu). Tuy nhiên, việc tìm ra các nhân tố đánh giá lịch trình đang gặp nhiều khó khăn, cần nghiên cứu thêm yêu cầu thực tế và cải thiện mô hình toán học @new_pesp1 @YAN201952, không được trình bày đầy đủ trong khóa luận này. Đây là thiếu sót khóa luận chưa thể khắc phục, cần cải thiện trong tương lai.


Khoá luận đã trình bày nghiên cứu mới nhất về bài toán lập lịch định kì(PESP) và phương hướng tiếp cận bài toán sử dụng định nghĩa hình thức và các SAT Solver. Hai giải thuật mã hóa đã được cài đặt và thực nghiệm nhằm giải các bài toán PESP. Kết quả thực nghiệm cho thấy phương pháp Order Encoding tỏ ra hiệu quả hơn nhiều so với phương pháp còn lại, thách thức nhiều giới hạn trong tương lai.


Quá trình nghiên cứu và thực nghiệm khóa luận đã giúp tôi có điều kiện tìm tòi, suy luận về bài toán lập lịch định kỳ cũng như phương pháp giải nó sử dụng kĩ thuật định nghĩa hình thức và SAT Solver. Khóa luận đã cho tôi những tri thức, trải nghiệm tuyệt vời khi nghiên cứu khoa học. Bên cạnh đó, tôi đã tiếp thu được nhiều bài học và phong cách làm việc, nghiên cứu khoa học từ thầy hướng dẫn.

Trên đây là toàn bộ nghiên cứu của tôi trong thời gian qua, tài liệu khó tránh khỏi sai sót, mong nhận được sự góp ý của các thầy cô và các bạn nghiên cứu về SAT, giúp tôi có thể hoàn thiện hơn nữa trong tương lai.

#pagebreak()

#show heading.where(depth: 1): it => pad(text(it.body, size: 24pt), x: 0pt, y: 40pt)

#set heading(numbering: none)
#counter(heading).update(100)

#bibliography("citation.bib") <citation>