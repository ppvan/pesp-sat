#import "@preview/acrotastic:0.1.1": *
#import "@preview/fletcher:0.5.1" as fletcher: diagram, node, edge
#import "@preview/cetz:0.2.1"


#import "@preview/ctheorems:1.1.3": *
#show: thmrules.with(qed-symbol: $square$)


#set math.equation(
  numbering: "(1)",
  supplement: none,
)
#show heading: it => {
  counter(math.equation).update(0)
  it
}

#show link: underline

#show ref: it => {
    // show link: 
  // provide custom reference for equations
  if it.element != none and it.element.func() == math.equation {
    // optional: wrap inside link, so whole label is linked
    link(it.target)[(#it)]
  } else {
    it
  }
}


#let theorem = thmbox("theorem", "Định lý", fill: rgb("#eeffee"), base_level: 1)
#let corollary = thmplain(
  "corollary",
  "Hệ quả",
  base: "theorem",
  titlefmt: strong,
  base_level: 1
)
#let definition = thmbox("definition", "Định nghĩa", inset: (x: 1.2em, top: 1em), base_level: 1)

#let example = thmplain("example", "Ví dụ").with(numbering: "1.1", base_level: 1)
#let proof = thmproof("proof", "Proof", base_level: 1)


#set page(paper: "a4", margin: (top: 2.5cm, bottom: 3cm, left: 3cm, right: 2cm), numbering: "1")

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

#set text(lang: "vi", font: "Latin Modern Roman", size: 13pt)


#set heading(numbering: "1.1.", supplement: "Chương")

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

#show figure.where(
  kind: table
): set figure.caption(position: top)

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


Hiện nay, hiệu năng của các bộ giải SAT đã cải thiện đáng kể và có thể được ứng dụng trong việc giải các bài toán NP-complete như: _Traveling Salesman,
Hamiltonian path
, graph k-coloring..._. Vấn đề lập lịch sự kiện định kỳ (Periodic Event Scheduling Problem) từ lâu đã được chứng minh là một vấn đề NP-complete. Các phương pháp hiện tại như lập trình ràng buộc (Constraint satisfaction Programing) hay quy hoạch số nguyên (Integer Programing) chưa thực sự hiệu quả với các bộ dữ liệu lớn.
Tài liệu này sẽ trình bày thuật toán chuyển hóa vấn đề lập lịch định kỳ (PESP) về bài toán SAT, sau đó giải bài toán sử dụng bộ giải SAT nhằm đạt được hiệu suất cao hơn.


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
  let supplement = "Chương "
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

Lập kế hoạch cho hệ thống tàu điện ngầm là một công việc đầy khó khăn và thử thách, bao gồm nhiều giai đoạn khác nhau, như: nghiên cứu thị trường, thiết lập tuyến đường, thiết lập phương tiện, lập lịch tàu chạy và đào tạo nhân viên. Các giai đoạn lập kế hoạch này liên quan mật thiết đến nhau và thường được tiến hành đổ thác theo thứ tự. Tuy nhiên, có thể quay lại bước trước đó để tối ưu khi các yêu cầu nghiệp vụ được làm rõ hơn.

#figure(
  image("image/railway-steps.svg"),
  caption: "Các giai đoạn lập kế hoạch xây dựng hệ thống tàu điện ngầm",
) <intro_fig>


+ *Nghiên cứu nhu cầu di chuyển*: Khảo sát thị trường và nhu cầu di chuyển của khách hàng nhằm thiết kế tuyến đường phù hợp

+ *Thiết lập tuyến đường*: Dựa trên nhu cầu di chuyển, ta thiết kế các tuyến đường nhằm đạt hiệu quả di chuyển cao nhất, quy trình này cần đảm bảo các chuyến tàu được kết nối với nhau và giảm thiểu số lần chuyển chuyến.

+ *Thiết lập phương tiện*: Dựa theo nhu cầu di chuyển và tuyến đường, ta cần lập danh sách các phương tiện (cần bao nhiêu phương tiện, sức chứa, tốc độ di chuyển...)

+ *Xây dựng lịch trình*: Khi biết rõ tuyến đường và công thông số phương tiện, ta có thể xây dựng lịch trình tàu chạy. Lịch trình cần đáp ứng các yêu chuẩn an toàn cũng như các yêu cầu về nghiệp vụ, và sẵn sàng cho các tình huống sự cố gián đoạn, hủy chuyến...

+ *Phân bổ nhân viên*: Tương tự, việc xây dựng lịch trình cho các nhân viên lái tàu, phục vụ, nhân viên sửa chữa, bảo hành cũng cần được quan tâm.

Trong đó, _xây dựng lịch trình_ là giai đoạn thiết yếu đối với hệ thống tàu điện ngầm. Việc cung cấp thời gian khởi hành và đến chính xác giúp lịch trình tàu hoạt động mượt mà và đáng tin cậy, đồng thời quản lý lưu lượng hành khách và ngăn ngừa tình trạng quá tải. Lịch trình hiệu quả cũng phối hợp các kết nối với các phương thức vận chuyển khác, cải thiện kế hoạch vận hành bằng cách lập kế hoạch bảo trì và phân bổ nhân sự, và tối ưu hóa việc sử dụng tài nguyên như số lượng tàu và đội ngũ nhân viên. Tổng thể, lịch trình đáng tin cậy dẫn đến sự hài lòng cao hơn của khách hàng và một hệ thống giao thông công cộng trơn tru, hiệu quả hơn.

Tuy nhiên, lập lịch trình tàu hỏa là một nhiệm vụ vô cùng khó khăn và tốn kém, vì phải đáp ứng nhiều tiêu chí phức tạp. Trước hết, thời gian đệm (recovery times) cần được tính toán để bù đắp cho những gián đoạn trong hệ thống, như sự thay đổi tốc độ do thời tiết hoặc thiên tai, và tình trạng tàu khởi hành muộn so với dự kiến. Để tránh làm gián đoạn toàn bộ hệ thống, lịch trình phải bao gồm thời gian đệm phù hợp. Tiếp theo, thời gian giãn cách tối thiểu (minimum headway time) là cần thiết để đảm bảo an toàn khi hai tàu sử dụng chung một đường ray và phải khởi hành cách nhau một khoảng thời gian tối thiểu. Tính kết nối (connections between trains) cũng rất quan trọng, vì thời gian đến và khởi hành của các tàu tại cùng một bến đỗ cần phải liên tục để phục vụ nhu cầu nối chuyến của hành khách. Cuối cùng, thời gian bảo trì (turn around times at termination) phải được tính toán để bao gồm thời gian cần thiết cho việc bảo trì động cơ, tiếp nhiên liệu và thay ca nhân viên ở ga tàu cuối trước khi tàu quay trở lại.

Trước đây, xây dựng lịch trình tàu chạy chủ yếu được làm thủ công @cyc, tốn nhiều chi phí cũng như dễ xảy ra sai sót. Vì vậy, trong thập kỷ trước, nhiều nghiên cứu nhằm hỗ trợ và tự động quá trình lập lịch đã được tiến hành @liebchen2007modeling @odijk1996constraint @yan2019multi. Hầu hết các nghiên cứu đều dựa trên mô hình _lập lịch sự kiện định kỳ_ (Periodic Event Schedule Problem - PESP), một mô hình nổi tiếng được giới thiệu bởi Serafini and Ukovich @pesp-intro. Tuy nhiên, các phương pháp hiện tại trong việc giải bài toán PESP như lập trình ràng buộc, quy hoạch số nguyên chưa hiệu quả với các bộ dữ liệu lớn. Trong khóa luận này, chúng tôi trình bày phương pháp giải bài toán PESP sử dụng bộ giải SAT và đề xuất một vài cải tiến về thuật toán mã hóa.

Phần còn lại của khóa luận được tổ chức như sau:

- *Chương 1*: Định nghĩa chi tiết các khái niệm trong bài toán _lập lịch sự kiện định kỳ_, một số cách tiếp cận hiện tại

- *Chương 2*: Trình bày kiến nền tảng về logic mệnh đề và các khái niệm liên quan đến bài toán SAT như NP-complete, Satisfiablility Problem, bộ giải SAT và quy trình giải bài toán thực tế sử dụng bộ giải SAT.

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
] <cons_def>

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
] <time_cons>


#definition[
  (Ràng buộc đối xứng). Cho $N = (nu, A, t_T)$ là một _mạng sự kiện định kỳ_ với tập ràng buộc $A = S union C$ với ràng buộc $a = ((i, j), [l_a, u_a]_t_T) in S, i, j in nu$. Hai tiềm năng $pi_i$ và $pi_j$ thỏa mãn ràng buộc đối xứng $a$ khi và chỉ khi:

  $
    pi_j + pi_i in [l_a, u_a]_t_T
  $
] <syms_cons>

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
] <time_cons_example>


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
  (Phép kéo theo): Mệnh đề kéo theo của hai mệnh đề $a, b$ là mệnh đề chỉ sai khi cả $a$ đúng $b$ sai. \
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
  (Phép tương đương): Mệnh đề tương đương của hai mệnh đề $a, b$ là mệnh đề chỉ đúng khi cả $a$ và $b$ cùng đúng hoặc cùng sai. \
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

Nhằm cung cấp nền tảng kiến thức, sau đây khóa luận sẽ trình bày chi tiết các khái niệm liên quan đến logic mệnh đề nói chung và bài toán SAT. Đây là cơ sở quan trọng cho @pesp_reduction

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


=== Bộ giải SAT

Bài toán SAT là bài toán thuộc lớp NP xuất hiện sớm nhất, đồng thời là bài toán đầu tiên được chứng minh là NP-complete @sat_np. Vì vậy, không tồn tại giải thuật tối ưu giải bài toán SAT có độ phức tạp đa thức. Tuy nhiên, nhiều nghiên cứu đã được tiến hành nhằm xây dựng chương trình giải bài toán SAT, thường gọi là các bộ giải SAT. Đầu vào chương trình thường là biểu thức logic dạng chuẩn tắc hội (CNF). Nếu biểu thức thỏa mãn được, đưa ra kết luận SAT và một nghiệm bất kỳ kèm chứng minh. Nếu không tồn tại nghiệm thoả mãn, kết luận UNSAT.

#figure(
  diagram(
    cell-size: 0pt,
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
  caption: "Sơ đồ đầu vào/đầu ra của bộ giải SAT",
)

Nhiều kĩ thuật đã được nghiên cứu nhằm cải thiện độ hiệu quả các bộ giải SAT theo thời gian, tiêu biểu như:

1. Thuật toán David-Putnam(1960)@putnam: Giảm số biến bằng thuật toán luận giải (resolusion).

2. Thuật toán Davis-Putnam-Logemann-Loveland (DPLL)@DPLL: Cải thiện thuật toán David-Putnam sử dụng kĩ thuật quay lui và nổi bọt đơn vị(unit propagation).

3. Conflict-Driven Clause Learning@cdcl: Mở rộng thuật toán DPLL, tối ưu giải thuật quay lui. Khi gặp một cặp mệnh đề mâu thuẫn và cần quay lui, thuật toán sẽ phân tích sai lầm này để tránh lặp lại tương tự. Thêm vào đó, thuật toán có thể quay lại trực tiếp điểm gây mâu thuẫn, giảm phần lớn nhánh cần tìm kiếm.

4. Những cải tiến khác về cơ sở dữ liệu, tiền xử lý, tận dụng khả năng xử lý song song @balyo2015hordesatmassivelyparallelportfolio@martins2012overview@hamadi2010manysat.

Do vậy, các bộ giải SAT hiện nay đã có khả năng giải các bài toán cực kì phức tạp, với hàng triệu biến và mệnh đề. Hằng năm, các cuộc thi về bộ giải SAT được tổ chức nhằm cải thiện hiệu suất thuật toán, tiêu biểu như #link("https://satcompetition.github.io/2024/", "SAT competition") #footnote[https://satcompetition.github.io/2024/]. Phần lớn những người tham gia công bố bộ giải SAT dưới dạng thư viện mã nguồn mở, có thể dễ dàng tích hợp và sử dung. Sau đây liệt kê một số Solver có ảnh hưởng quan trọng trong lịch sử phát triển của các bộ giải SAT:

- *CaDiCal*: CaDiCal là bộ giải SAT dựa trên thuật toán CDCL Mục tiêu chính của CaDiCal không phải hiệu năng, mà là một cơ sở thuật toán dễ hiểu và mở rộng. Vì vậy đặt nền móng cho nhiều bộ giải SAT khác sau này.

- *Kissat*: Dựa trên CaDiCal, nhưng được viết lại bằng C, với nhiều cải tiến về cấu trúc dữ liệu, xếp lịch tiến trình xử lý, tối ưu hóa cài đặt thuật toán. Xếp hạng đầu trong hạng mục các công cụ giải SAT tuần tự trong cuộc thi giải SAT quốc tế năm 2022.
- *MiniSAT*: Một bộ giải SAT hiện đại, trở thành tiêu chuẩn trong công nghiệp. Dựa trên thuật toán CDCL, và giành chiến thắng trong cuộc thi giải SAT quốc tế năm 2005. Đây vẫn là một trong những bộ giải SAT được sử dụng nhiều nhất do chất lượng mã nguồn cao, rõ ràng và dễ cải tiến.

- *Glucose*: bộ giải SAT được dựa trên MiniSAT, áp dụng thêm nhiều kỹ thuật mới như phương pháp học mệnh đề hiện đại và giải song song.

- *Gini*: Một solver hiện đại được viết bằng Go, điểm đặc biệt của solver này là giao thức chia sẻ tính toán, cho phép giải song song sử dụng các goroutine. Đây cũng là solver được chọn để giải bài toán PESP khi thực nghiệm.

Để giải các bài toán thực tế sử dụng bộ giải SAT, ta cần định nghĩa hình thức các yêu cầu nghiệp vụ của bài toán thành các logic mệnh đề, giải bài toán SAT, sau đó suy luận kết quả từ đầu ra của bộ giải SAT. Sơ đồ có thể giải một bài toán sử dụng bộ giải SAT được minh họa trong @fig_1. Thuật toán encoding và decoding là một quá trình phức tạp, chương tiếp theo sẽ minh họa rõ hơn quá trình này.

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
      node(solver, "bộ giải SAT", shape: fletcher.shapes.diamond, inset: 8pt)
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
  caption: "Sơ đồ giải bài toán thực tế sử dụng bộ giải SAT",
) <fig_1>

#pagebreak(weak: true)
= Mô hình bài toán PESP về biểu diễn SAT <pesp_reduction>

Trong chương này, khóa luận sẽ trình bày thuật toán nhằm chuyển hóa một bài toán PESP thành bài toán SAT.
Điều này có nghĩa là, khi cho trước một mạng lưới sự kiện định kỳ N, ta cần tìm ra một lịch trình hợp lệ hoặc chứng minh rằng không tồn tại một giải pháp như vậy thỏa mãn. Các thuộc tính và ràng buộc của bài toán phải được mã hóa thành bài toán SAT, tức là một công thức mệnh đề ở dạng chuẩn tắc hội (CNF), và sau đó được xử lý bởi một bộ giải SAT.

Nếu bộ giải SAT trả về UNSAT, chúng ta biết rằng không tồn tại một lịch trình hợp lệ cho mạng lưới sự kiện định kỳ N đã mã hóa. Ngược lại, nếu nhận được một nghiệm cho công thức mệnh đề, điều đó đảm bảo rằng có tồn tại một lịch trình hợp lệ cho N. Tính chính xác của thuật toán mã hóa các ràng buộc của bài toán về dạng chuẩn tắc hội và cách truy xuất lịch trình hợp lệ từ nghiệm sẽ được chứng minh ở phần sau.

Sẽ có hai cách mã hóa khác nhau được giới thiệu cho một bài toán PESP đã được giảm thành bài toán SAT. Đầu tiên, mã hóa trực tiếp cho các biến của các miền hữu hạn sẽ được trình bày ở Mục 3.2 và cách triển khai cụ thể cho PESP ở Mục 3.3. Thứ hai, mã hóa thứ tự cho các biến có miền hữu hạn có thứ tự sẽ được định nghĩa trong Mục 3.4 và cách nó được sử dụng để mã hóa PESP thành bài toán SAT ở Mục 3.5.

Cuối chương này, hai phương pháp sẽ được so sánh để đưa ra đánh giá và nhận định về việc mã hóa thứ tự có thể giải quyết bài toán PESP nhanh hơn bao nhiêu so với mã hóa trực tiếp và kích thước của nó nhỏ hơn bao nhiêu.

// == Sơ đồ tổng quan


// #figure(
//   diagram(
//     spacing: 2em,
//     node-stroke: 1pt,
//     node-inset: 8pt,
//     node-corner-radius: 4pt,
//     {
//       let (input, encoding, solver, desiion, decoding) = ((-1, 1), (0, 1), (0, 2), (1, 2), (2, 2))

//       let (unsat, sat) = ((0, 5), (0, 3))
//       let result = (3, 2)
//       let verification = (2, 3)
//       let encoding_cons = (2, 1)

//       let direct_encode
//       // set node(stroke: 1pt)

//       node(input, [$N = (nu, A, t_T)$])
//       node(encoding, "Encoding Potentials")
//       node(encoding_cons, "Exclude unfeasible pairs")
//       node(solver, "Gini bộ giải SAT", shape: fletcher.shapes.diamond, inset: 8pt)
//       node(decoding, "Decoding Module")
//       node(unsat, "No result")
//       node(result, "Output")
//       node(verification, "Verification")

//       edge(input, encoding, "->")
//       edge(encoding, encoding_cons, "->")
//       edge(encoding_cons, solver, "->")
//       edge(solver, decoding, "->", [SAT])
//       edge(input, encoding, "->")
//       edge(solver, unsat, "->", [UNSAT])
//       edge(decoding, result, "->")
//       edge(result, verification, "->")
//     },
//   ),
//   caption: "Sơ đồ tổng quan giải bài toán PESP sử dụng bộ giải SAT",
// )

Nhiều nghiên cứu liên quan đề xuất hai phương pháp mã hóa bài toán lập lịch định kỳ (PESP) về bài toán SAT là Direct Encoding và Order Encoding.

== Mã hóa đại lượng rời rạc <encoding>

Các biến số trong bài toán PESP (các tiềm năng sự kiện) là các biến đại số rời rạc, tức là chúng có thể nhận các giá trị từ một tập hữu hạn, thay vì có thể nhận bất kỳ giá trị nào trong một khoảng liên tục. Ví dụ, một biến rời rạc có thể đại diện cho một khoảng thời gian nhất định giữa các sự kiện, và giá trị của nó có thể là các số nguyên từ 1 đến 10, biểu thị số phút. Tuy nhiên, logic mệnh đề và biểu thức chuẩn tắc hội chỉ có thể biểu diễn hai trạng thái logic là 0 và 1, tương ứng với giá trị "đúng" và "sai". Điều này tạo ra một vấn đề khi ta cần biểu diễn các giá trị rời rạc, vì không thể trực tiếp gán chúng vào các biến logic chỉ có hai trạng thái.

Do đó, chúng ta cần tìm cách mã hóa các biến rời rạc này sang không gian logic, tức là chuyển đổi các biến có nhiều giá trị tiềm năng sang các tổ hợp biến logic có thể được biểu diễn trong biểu thức mệnh đề. Ví dụ, nếu một biến rời rạc có thể nhận ba giá trị là 1, 2 và 3, ta có thể mã hóa chúng bằng cách sử dụng hai biến logic $x_1$ và $x_2$, trong đó:

- $x_1 = 0$ và $x_2 = 0$ đại diện cho giá trị 1,
- $x_1 = 0$ và $x_2 = 1$ đại diện cho giá trị 2,
- $x_1 = 1$ và $x_2 = 0$ đại diện cho giá trị 3.

Cách mã hóa này cho phép chúng ta sử dụng công cụ của logic mệnh đề để xử lý các biến rời rạc, biến chúng thành các biến logic có thể được giải bằng bộ giải SAT. Điều quan trọng là việc chuyển đổi này phải được thực hiện sao cho các ràng buộc của bài toán ban đầu vẫn được duy trì trong không gian logic, đảm bảo rằng các giá trị logic được chọn phải tương ứng với một nghiệm hợp lệ trong miền rời rạc. Các phương pháp mã hóa như vậy được đề xuất và cải tiến bởi nhiều nghiên cứu, tiêu biểu như Direct Encoding @direct_encode, Product Encoding @chen2010new, Support Encoding... Sau đây khóa luận giới thiệu về hai phương pháp ứng dụng trong giải bài toán PESP: Mã hóa trực tiếp (Direct Encoding) và mã hóa thứ tự (Order Encoding).

=== Mã hóa trực tiếp <direct>

Mã hóa trực tiếp, hay còn gọi là mã hóa nhị thức, là phương pháp đơn giản nhất để mã hóa các biến rời rạc. Nguyên lý chính của phương pháp này là loại bỏ từng cặp giá trị không thể cùng thỏa mãn đồng thời, đảm bảo rằng chỉ một giá trị trong số các giá trị có thể được chọn. Để làm rõ hơn, ta xét ví dụ sau:

#example[
  Cho $x in {1, 2, 3}$. Hiển nhiên ta có những mệnh đề đúng sau:

  $
    x = 1 or x = 2 or x = 3 \
    x = 1 => x != 2 and x != 3\
    x = 2 => x != 1 and x != 3 \
    x = 3 => x != 1 and x != 2 \
  $
  Sử dụng các biến logic: $x_1, x_2, x_3$ tương ứng với mệnh đề $x = 1, x = 2, x = 3$ ta có:

  $
    x_1 or x_2 or x_3\
    x_1 => not x_2 and not x_3\
    x_2 => not x_1 and not x_3\
    x_3 => not x_1 and not x_2\
  $
  $<=>$
  $
    x_1 or x_2 or x_3\
    (x_1 => not x_2) and (x_1 => not x_3)\
    (x_2 => not x_1) and (x_2 => not x_3)\
    (x_3 => not x_1) and (x_3 => not x_2)\
  $
  $<=>$
  $
    x_1 or x_2 or x_3\
    (not x_1 or not x_2) and (not x_1 or not x_3)\
    (not x_2 or not x_1) and (not x_2 or not x_3)\
    (not x_3 or not x_1) and (not x_3 or not x_2)\
  $
  $<=>$
  $
    (x_1 or x_2 or x_3) and
    (not x_1 or not x_2) and (not x_2 or not x_3) and (not x_1 or not x_3)
  $
]

Tổng quát hóa ví dụ trên, ta có thể áp dụng phương pháp mã hóa trực tiếp cho bất kỳ tập giá trị hữu hạn nào $x in {1, 2, ..., n}$. Khi đó, mã hóa trực tiếp được định nghĩa như sau:

#definition[
  Cho $x in X| X = {1, 2, ..., n| n in NN}$ và các mệnh đề: $x_1, x_2, ..., x_n$ đúng khi và chỉ khi $x = n$. Ta định nghĩa ánh xạ:
  $
    "encode_direct"(X) = or.big_(i=1)^n x_i and (and.big_(i=1)^n and.big_(j=i+1)^n (not x_i or not x_j))
  $
] <def_direct>

Phương pháp mã hóa trực tiếp đảm bảo rằng chỉ một biến logic duy nhất có giá trị "đúng" (true) trong khi tất cả các biến còn lại phải có giá trị "sai" (false) trong mọi suy diễn hợp lệ $I$.

=== Mã hóa thứ tự <order_encode>

Trái ngược với @direct, phần này giả định rằng miền hữu hạn có thứ tự. Ví dụ tốt nhất cho điều này là một tập con của tập số tự nhiên $NN$. Các số này luôn có thứ tự theo quan hệ "<". Trong phần tiếp theo, ta sẽ thảo luận cách mã hóa hiệu quả thuộc tính này vào một công thức mệnh đề. Vì trong khóa luận này, ta chỉ xét các biến có miền là một tập con,chính xác hơn là một khoảng, của các số tự nhiên $[a, b]$, nên ta biết cách áp dụng quan hệ thứ tự "<" của chúng. Nhìn chung, mọi tập hợp đều có thể xác định quan hệ thứ tự cụ thể. Tương tự, cùng tiếp cận phương pháp mã hóa này với một ví dụ.

#example[
  Cho $x in {1, 2, 3, 4, 5} = [1, 5] subset NN$. Ta có các mệnh đề đúng sau:
  $
    &x >= 1 => not(x <= 0)\
    &x <= 5\
    &forall i in {1, 2, 3, 4, 5}: (x <= i - 1) -> (x <= i)\
  $
  $<=>$
  $
    &x >= 1 => not(x <= 0)\
    &x <= 5\
    &forall i in {1, 2, 3, 4, 5}: not (x <= i - 1) or (x <= i)
  $
  $<=>$
  $
    (not x <= 0) and (not x <= 1 or x <= 2) and (not x <= 2 or x <= 3) and (not x <= 3 or x <= 4) and (x <= 5)
  $
  Thế các mệnh đề: $x_i <=> x <= i$ ta có:
  $
    (not x_0) and (not x_1 or x_2) and (not x_2 or x_3) and (not x_3 or x_4) and (x_5)
  $
] <order_exp>

Tương tự, ta có thể áp dụng phương pháp mã hóa trực tiếp cho bất kỳ tập giá trị hữu hạn *có thứ tự* nào $x in {1, 2, ..., n}$. Khi đó, mã hóa thứ tự được định nghĩa như sau:

#definition[
  Cho $x in X| X = {1, 2, ..., n| n in NN}$ và các mệnh đề: $x_0, x_1, x_2, ..., x_n$ đúng khi và chỉ khi $x <= n$. Ta định nghĩa ánh xạ:
  #set math.equation(numbering: "(1)")
  $
    "encode_order(X)" = (not x_0) and and.big_(i = 2)^(n - 1)(not x_(i - 1) or x_i) and (x_n)
  $
] <ahihi>

Khác với mã hóa trực tiếp, mệnh đề trong mã hóa thứ tự mang ý nghĩa rộng hơn:

$
  x_i <=> x <= i
$

Điều này có nghĩa, với mỗi suy diễn I, việc trích xuất thông tin từ mệnh đề không quá đơn giản:

$
  x_i^I = "true" <=> x <= i \
  x_i^I = "false" <=> x lt.eq.not i \
  => x = "?"
$

Vì vậy ta cần chứng minh luôn có thể suy diễn thông tin từ một suy diễn khi mã hóa thứ tự, được chứng minh trong định lý sau:

#theorem[
  Cho $x in X| X = {1, 2, 3, ..., n} | n in NN$ với $I$ là một suy diễn thỏa mãn @ahihi:
  $
    I tack.r.double "encode_order"(X) <=> exists k in [1, n]: &forall i in [1, k - 1]: I tack.r.double.not x_i\
    &forall j in [k, n]: I tack.r.double x_j
  $
]

Do đó, ta có cách trích xuất giá trị của $x$ từ một suy diễn $I$ như sau:

#definition[
  Cho $x in X| X = {1, 2, 3, ..., n} | n in NN$ với $I tack.r.double "encode_order(X)"$. Khi đó tồn tại duy nhất một giá trị $k in X$ mà:
  $
    x = k in X <=> x_(k-1)^I = "false" and x_k^I = "true"
  $
] <extract>

Để hiểu rõ hơn các truy xuất thông tin từ suy diễn, cùng xem lại @order_exp:

#example[
  Cho $x in X = {1, 2, 3, 4, 5}$
  $
    "encode_order(X)" = &(not x <= 0) and (not x <= 1 or x <= 2) and \ &(not x <= 2 or x <= 3) and (
      not x <= 3 or x <= 4
    ) and (x <= 5)
  $
  Xét một suy diễn hợp lệ $I$:
  $
    x_0 = "false" \
    x_1 = "false" \
    x_2 = "false" \
    x_3 = "true" \
    x_4 = "true" \
    x_5 = "true"
  $

  Từ @extract, ta suy ra: x = 3
]

== Mã hóa bài toán PESP

=== Mã hóa trực tiếp PESP

#figure(
  diagram(
    spacing: 2em,
    node-stroke: 1pt,
    node-inset: 8pt,
    node-corner-radius: 4pt,
    {
      let nodes = ((0, 0), (1, 0), (2, 0))

      node((0, 0), $N = (nu, A, t_T)$)
      node((1, 1), $"encode"(nu)$)
      node((1, -1), $"encode"(A)$)
      node((2, 0), $"encode"(nu, A, t_T)$)
      node((3, 0), $"bộ giải SAT"$)
      node((3, -1), $"No schedule"$)
      node((3, 1), $"Interpretation" I$)
      node((3, 2), $"Schedule" Pi_v$)


      edge((0, 0), (1, 1), "->")
      edge((0, 0), (1, -1), "->")
      edge((1, 1), (2, 0), "->")
      edge((1, -1), (2, 0), "->")
      edge((2, 0), (3, 0), "->")
      edge((3, 0), (3, -1), "->", [UNSAT])
      edge((3, 0), (3, 1), "->", [SAT])
      edge((3, 1), (3, 2), "->", [Decode (I)])
    },
  ),
  caption: "Sơ đồ tổng quan giải bài toán PESP với mã hóa trực tiếp",
)


Để mã hóa trực tiếp bài toán PESP thành biểu thức mệnh đề, trước tiên ta cần mã hóa các tiềm năng sự kiện $pi_i$. Nhắc lại @cor1, các tiềm năng sự kiện $pi_i$ đều thỏa mãn:

#set math.equation(numbering: "(1)")

$
  forall pi_i in nu | pi_i in [0, t_T - 1] = {0, 1, 2, ..., t_T - 1}
$

Vì vậy, ta dễ dàng mã hóa toàn bộ tiềm năng sự kiện dựa theo @def_direct:

$
  Omega_("direct")^nu := and.big_(n in nu) "encode_direct"(pi_n)
$ <direct_vars>

do $"encode_direct"(pi_n)$ là một biểu thức chuẩn tắc hội và $Omega_("direct")^n$ là hội những mệnh đề này, $Omega_("direct")^nu$ là một biểu thức dạng chuẩn tắc hội.


Với mỗi suy diễn I thoả mãn @direct_vars, ta luôn suy ra được một lịch trình hợp lệ theo định lý sau:
$
  forall n in nu: Pi_(nu)(n) = i <=> p_(pi_(n), i)^(I) = "true"
$ <direct_extract> trong đó $p_(pi_(n), i)^(I)$ là mệnh đề tương ứng với $pi_n = i$ trong suy diễn I.

Tiếp theo, ta cần mã hóa các ràng buộc thời gian và ràng buộc đối xứng như ở @time_cons và @syms_cons. Ý tưởng chính là loại các cặp tiềm năng sự kiện không thỏa mãn ràng buộc, chuyển hóa chúng thành các mệnh đề. Do tập giá trị của các tiềm năng là hữu hạn ($[0, t_T - 1]$), ta loại tất cả các khả năng không khỏa mãn bằng các mệnh đề đảo nghịch.

Thật vậy, ta xét một ràng buộc bất kỳ $a = ((i, j), [l_a, u_a]_(t_T))in A$, ta định nghĩa:

$
  "encode_direct_cons"(a) = and.big_(m, n in P_a)(not p_(pi_i, m) or not p_(pi_j, n))
$ <direct_cons> trong đó:

- $m, n in [0, t_T - 1]$
- $p_(pi_i, m) , p_(pi_j, n)$ là các biến logic tương ứng với các tiềm năng: $pi_i = m, pi_j = n$
- $P_a := {(m, n) | (m, n) "không thỏa mãn" a}$

Nhằm hiểu rõ hơn @direct_cons, ta xét ví dụ cụ thể sau:

#example[
  Cho hai sự kiện A, B và ràng buộc thời gian $a = ((A, B), [3, 7]_(8))$ như ở @time_cons_example.

  Dễ thấy: $(pi_A, pi_B) = (6, 7)$ không thỏa mãn $a$ ($7 - 6 = 1 in.not [3, 7]_8$). Vậy ta cần loại khả năng $pi_A = 6 "và" pi_B = 7$, tức là
  $
    &not (pi_A = 6 and pi_B = 7)\
    <=>& not (p_(pi_A,6) and p_(pi_B, 7))\
    <=>& not p_(pi_A,6) or not p_(pi_B,7)
  $

  Tương tự ta có:
  $
    P_a = {
      &(0, 0), (0, 1), (0, 2), (1, 0), (1, 1), (1, 2),\
      &(1, 3), (2, 0), (2, 1), (2, 2), (2, 3), (2, 4), (3, 0),\
      &(3, 1), (3, 2), (3, 3), (3, 4), (3, 5), (4, 0), (4, 1),\
      &(4, 2), (4, 3), (4, 4), (4, 5), (4, 6), (5, 0), (5, 1),\
      &(5, 2), (5, 3), (5, 4), (5, 5), (5, 6), (5, 7), (6, 0),\
      &(6, 1), (6, 2), (6, 3), (6, 4), (6, 5), (6, 6), (6, 7),\
      &(7, 0), (7, 1), (7, 2), (7, 3), (7, 4), (7, 5), (7, 6),\
      &(7, 7)
    }\
    => "encode_direct_cons"&(a) = (not p_(pi_A,0) or not p_(pi_B,3)) and ... and (not p_(pi_A,7) or not p_(pi_B,7))
  $
]

Áp dụng @direct_cons với tất cả ràng buộc $a in A$, ta có được biểu thức mã hóa trực tiếp các ràng buộc:

$
  Psi_"direct"^A := and.big_(a in A) "encode_direct_cons(a)"
$

Cuối cùng, sử dụng @direct_vars và @direct_cons, ta mã hóa trực tiếp toàn bộ mạng định kỳ như sau:

$
  "encode_direct_pesp"(nu, A, t_T) = Omega_"direct"^nu and Psi_"direct"^A
$ với $Omega_"direct"^nu, Psi_"direct"^A$ là các biểu thức có dạng tương ứng như @direct_vars và @direct_cons.

Dễ thấy $Omega_"direct"^nu$ thỏa mãn dạng chuẩn tắc hội. Tương tự, $Psi_"direct"^A$ là hội của các biểu thức chuẩn tắc hội, nên cũng là một biểu thức chuẩn tắc hội. Do đó, $"encode_direct_pesp"(nu, A, t_T)$ cũng có dạng chuẩn tắc hội. Như vậy, chúng ta đã thành công trong việc mã hóa bài toán PESP thành một biểu thức chuẩn tắc hội, mà các bộ giải SAT hiện đại có thể giải quyết một cách dễ dàng. Từ suy diễn $I$ thu được từ bộ giải SAT, chúng ta có thể dễ dàng truy xuất ra lịch trình hợp lệ bằng cách sử dụng hàm @direct_extract.

=== Mã hóa thứ tự PESP

#figure(
  diagram(
    spacing: 2em,
    node-stroke: 1pt,
    node-inset: 8pt,
    node-corner-radius: 4pt,
    {
      let nodes = ((0, 0), (1, 0), (2, 0))

      node((0, 0), $N = (nu, A, t_T)$)
      node((1, 1), $"encode"(A)$)
      node((1, -1), $"encode"(nu)$)
      node((2, 0), $"encode"(nu, A, t_T)$)
      node((3, 0), $"SAT Solver"$)
      node((3, -1), $"No schedule"$)
      node((3, 1), $"Interpretation" I$)
      node((3, 2), $"Schedule" Pi_v$)


      edge((0, 0), (1, 1), "->")
      edge((0, 0), (1, -1), "->")
      edge((1, 1), (2, 0), "->")
      edge((1, -1), (2, 0), "->")
      edge((2, 0), (3, 0), "->")
      edge((3, 0), (3, -1), "->", [UNSAT])
      edge((3, 0), (3, 1), "->", [SAT])
      edge((3, 1), (3, 2), "->", [Decode (I)])
    },
  ),
  caption: "Sơ đồ tổng quan giải bài toán PESP với mã hóa thứ tự",
)




Tương tự mã hóa trực tiếp, khóa luận sẽ trình bày phương pháp mã hóa thứ tự gồm hai phần chính.
Trước hết, ta mã hóa các tiềm năng sự kiện như đã trình bày ở @order_encode.
Sau đó ta sẽ mã hóa các ràng buộc trong miền xác định thứ tự. Cuối cùng, ta tổng hợp các mệnh đề và giải bằng bộ giải SAT.

Để mã hóa trực tiếp bài toán PESP thành biểu thức mệnh đề, trước tiên ta cần mã hóa các tiềm năng sự kiện $pi_i$. Nhắc lại @cor1, các tiềm năng sự kiện $pi_i$ đều thỏa mãn:


$
  forall pi_i in nu | pi_i in [0, t_T - 1] <=> 0 <= pi_i <= t_T - 1
$

Vì vậy, ta dễ dàng mã hóa toàn bộ tiềm năng sự kiện dựa theo @ahihi:

$
  Omega_("order")^nu := and.big_(n in nu) "encode_order"(pi_n)
$

do $"encode_order"(pi_n)$ là một biểu thức chuẩn tắc hội và $Omega_("order")^n$ là hội những mệnh đề này, $Omega_("order")^nu$ là một biểu thức dạng chuẩn tắc hội.

Tiếp theo, khóa luận trình bày chi tiết cách mã hóa ràng buộc thời gian và ràng buộc đối xứng. Tư tưởng căn bản sẽ tương tự như mã hóa trực tiếp, loại bỏ các miền không khỏa mãn trong tập xác định. Tuy nhiên khi sử dụng mã hoá thứ tự, ta có thể loại bỏ từng vùng các hình chữ nhật song song với trục tọa độ do đó tối ưu hiệu quả mã hóa như @order_diagram


*Mã hóa thứ tự ràng buộc thời gian*


#figure(
  cetz.canvas({
    import cetz.draw: *
    set-style(
      stroke: 0.4pt,
      mark: (
        transform-shape: false,
        fill: black,
      ),
    )
    // vars
    let T = 8
    let width = 8
    let height = 8
    let a = 2
    let b = 4
    import cetz.draw: *
    set-style(
      stroke: 0.4pt,
      mark: (
        transform-shape: false,
        fill: black,
      ),
    )


    // Trục tọa độ
    grid((0, 0), (width - 1, height - 1), step: 1, stroke: gray + 0.2pt)
    line((0, 0), (width, 0), mark: (end: "stealth"))
    line((0, 0), (0, height), mark: (end: "stealth"))

    // tick
    let x = 0
    while x < width {
      line((x, -1pt), (x, 1pt))
      line((-1pt, x), (1pt, x))
      x += 1
    }

    // text ab, 3, 5, 8
    content((width, -0.5), $pi_A$)
    content((-0.25, -0.25), $0$)
    content((-0.5, height), $pi_B$)

    let fill-color = color.mix((blue, 40%), white).opacify(-40%)
    line(
      (0, a),
      (0, b),
      (T - 1 - b, T - 1),
      (T - 1 - a, T - 1),
      (0, a),
      fill: fill-color,
      stroke: fill-color.darken(20%),
    )
    line(
      (T - b, 0),
      (T - a, 0),
      (T - 1, a - 1),
      (T - 1, b - 1),
      (T - b, 0),
      fill: fill-color,
      stroke: fill-color.darken(20%),
    )


    let i = 0
    let j = 0
    while i < width {
      j = 0
      while j < height {
        if (j - i >= a and j - i <= b) {
          circle((i, j), radius: 1pt, fill: color.mix((blue, 100%)))


        }

        if (j - i >= a - T and j - i <= b - T) {
          circle((i, j), radius: 1pt, fill: color.mix((blue, 100%)))
        }


        j += 1
      }
      i += 1
    }

    content((-0.5, a), $#a$)
    content((-0.5, b), $#b$)
    content((T - b, -0.5), $#(T - b)$)
    content((T - a, -0.5), $#(T - a)$)
    content((T - 1, -0.5), $#(T - 1)$)
    content((-0.5, T - 1), $#(T - 1)$)


    let error-color = color.mix((red, 70%), white).opacify(-40%)
    rect((3, 2), (5, 4), fill: error-color, stroke: error-color.darken(40%))

    line((3, 0), (3, 2), stroke: (dash: "dashed", paint: red))
    line((5, 0), (5, 2), stroke: (dash: "dashed", paint: red))
    line((0, 2), (3, 2), stroke: (dash: "dashed", paint: red))
    line((0, 4), (3, 4), stroke: (dash: "dashed", paint: red))

    for i in (3, 4, 5) {
      for j in (2, 3, 4) {
        circle((i, j), radius: 1pt, fill: color.mix((red, 100%)))
      }
    }


  }),
  caption: [Minh họa loại bỏ miền không thỏa mãn ràng buộc thời gian $((A, B), [2, 4]_8)$],
) <order_diagram>


#let pesp_diagram = (a, b, T) => {
  cetz.canvas({
    import cetz.draw: *
    set-style(
      stroke: 0.4pt,
      mark: (
        transform-shape: false,
        fill: black,
      ),
    )
    // vars
    let width = T
    let height = T


    // Trục tọa độ
    grid((0, 0), (width - 1, height - 1), step: 1, stroke: gray + 0.2pt)
    line((0, 0), (width, 0), mark: (end: "stealth"))
    line((0, 0), (0, height), mark: (end: "stealth"))

    // tick
    let x = 0
    while x < width {
      line((x, -1pt), (x, 1pt))
      line((-1pt, x), (1pt, x))
      x += 1
    }

    // text ab, 3, 5, 8
    content((width, -0.5), $pi_A$)
    content((-0.25, -0.25), $0$)
    content((-0.5, height), $pi_B$)

    let fill-color = color.mix((blue, 40%), white).opacify(-40%)
    line(
      (0, a),
      (0, b),
      (T - 1 - b, T - 1),
      (T - 1 - a, T - 1),
      (0, a),
      fill: fill-color,
      stroke: fill-color.darken(20%),
    )
    line(
      (T - b, 0),
      (T - a, 0),
      (T - 1, a - 1),
      (T - 1, b - 1),
      (T - b, 0),
      fill: fill-color,
      stroke: fill-color.darken(20%),
    )


    let i = 0
    let j = 0
    while i < width {
      j = 0
      while j < height {
        if (j - i >= a and j - i <= b) {
          circle((i, j), radius: 1pt, fill: color.mix((blue, 100%)))


        }

        if (j - i >= a - T and j - i <= b - T) {
          circle((i, j), radius: 1pt, fill: color.mix((blue, 100%)))
        }


        j += 1
      }
      i += 1
    }

    content((-0.5, a), $#a$)
    content((-0.5, b), $#b$)
    content((T - b, -0.5), $#(T - b)$)
    content((T - a, -0.5), $#(T - a)$)
    content((T - 1, -0.5), $#(T - 1)$)
    content((-0.5, T - 1), $#(T - 1)$)

  })
}

Để hiểu ý tưởng chính của thuật toán, ta xét ví dụ cụ thể sau:

#example[
  Cho ràng buộc thời gian $a = ((A, B), [2, 4]_8)$ với $pi_A, pi_B$ lần lượt là các tiềm năng tương ứng với A và B.
  Đặt $p_(pi_A, i), p_(pi_B, j)$ lần lượt là các biến logic tương ứng với mệnh đề $pi_A <= i, pi_B <= j$
] <cons_example>


Dễ thấy một vùng không thỏa mãn ràng buộc như minh họa ở @order_diagram:
$
  r = ([2, 4] times [2, 4]) in P_a
$

$
  &<=> exists.not (pi_A, pi_B): pi_A <= 4, pi_A >= 2, pi_B <= 4, pi_B >= 2\
  &<=> not(pi_A <= 4 and pi_A >= 2 and pi_B <= 4 and pi_B >= 2)\
  &<=> not(pi_A <= 4 and not pi_A <= 1 and pi_B <= 4 and not pi_B <= 1)\
  &<=> not pi_A <= 4 or pi_A <= 1 or not pi_B <= 4 or pi_B <= 1\
  &<=> not p_(pi_A, 4) or p_(pi_A, 1) or not p_(pi_B, 4) or p_(pi_B, 1) = F
$

Do $F$ là một mệnh đề chuẩn tắc hội, ta có được một mệnh đề ràng buộc tương ứng với phần bị loại bỏ trong @order_diagram.
Như vậy ta đã biết cách loại bỏ một hình chữ nhật khỏi không gian tìm kiếm. Vấn đề còn lại là tìm tất cả các hình chữ nhật nhằm lấp đầy vùng không thỏa mãn.


Cùng xem lại @order_diagram ở một góc nhìn khác. Ta thấy hai miền nghiệm tương ứng với $[2. 4], [-6, -4]$ và khoảng vô nghiệm giữa chúng $(-4, 2)$. Sau đây ta sẽ định nghĩa các hàm số nhằm phủ miền này bằng tập hợp các hình chữ nhật ở @order_diagram. Bằng cách tương tự, ta cũng có thể phủ hai vùng vô nghiệm còn lại($(4, 8), (-8, -6)$).


#figure(
  cetz.canvas({
    import cetz.draw: *
    set-style(
      stroke: 0.4pt,
      mark: (
        transform-shape: false,
        fill: black,
      ),
    )
    // vars
    let T = 8
    let width = 8
    let height = 8
    let a = 2
    let b = 4
    import cetz.draw: *
    set-style(
      stroke: 0.4pt,
      mark: (
        transform-shape: false,
        fill: black,
      ),
    )


    // Trục tọa độ
    grid((0, 0), (width - 1, height - 1), step: 1, stroke: gray + 0.2pt)
    line((0, 0), (width, 0), mark: (end: "stealth"))
    line((0, 0), (0, height), mark: (end: "stealth"))

    // tick
    let x = 0
    while x < width {
      line((x, -1pt), (x, 1pt))
      line((-1pt, x), (1pt, x))
      x += 1
    }

    // text ab, 3, 5, 8
    content((width, -0.5), $pi_A$)
    content((-0.25, -0.25), $0$)
    content((-0.5, height), $pi_B$)

    let fill-color = color.mix((blue, 40%), white).opacify(-40%)
    line(
      (0, a),
      (0, b),
      (T - 1 - b, T - 1),
      (T - 1 - a, T - 1),
      (0, a),
      fill: fill-color,
      stroke: fill-color.darken(20%),
    )
    line(
      (T - b, 0),
      (T - a, 0),
      (T - 1, a - 1),
      (T - 1, b - 1),
      (T - b, 0),
      fill: fill-color,
      stroke: fill-color.darken(20%),
    )


    let i = 0
    let j = 0
    while i < width {
      j = 0
      while j < height {
        if (j - i >= a and j - i <= b) {
          circle((i, j), radius: 1pt, fill: color.mix((blue, 100%)))


        }

        if (j - i >= a - T and j - i <= b - T) {
          circle((i, j), radius: 1pt, fill: color.mix((blue, 100%)))
        }


        j += 1
      }
      i += 1
    }

    content((-0.5, a), $#a$)
    content((-0.5, b), $#b$)
    content((T - b, -0.5), $#(T - b)$)
    content((T - a, -0.5), $#(T - a)$)
    content((T - 1, -0.5), $#(T - 1)$)
    content((-0.5, T - 1), $#(T - 1)$)

    line((-1, 1), (6, 8))
    content((3, 4), $pi_B - pi_A < 2$, angle: 45deg)
    line((3, -1), (8, 4))
    content((5, 2), $pi_B - pi_A > 4 - t_T = -4$, angle: 45deg)

  }),
  caption: [Bản chất của miền vô nghiệm$((A, B), [2, 4]_8)$],
)


#definition[
  Cho $u, l in ZZ$ là hai số nguyên với u < l.
  $
    delta: ZZ times ZZ &-> ZZ\
    (l, u) &|-> l - u - 1
  $ được gọi là _khoảng cách trong_ giữa $u$ và $l$.
]


#definition[
  Cho $u, l in ZZ$ là hai số nguyên với u < l.
  $
    delta y: ZZ times ZZ &-> ZZ\
    (l, u) &|-> floor(frac(delta(l, u), 2))
  $ được gọi là chiều rộng của hình chữ nhật giữa $u$ và $l$.
]



#definition[
  Cho $u, l in ZZ$ là hai số nguyên với u < l.
  $
    delta x: ZZ times ZZ &-> ZZ\
    (l, u) &|-> ceil(frac(delta(l, u), 2)) - 1
  $ được gọi là chiều dài của hình chữ nhật giữa $u$ và $l$.
]


#let delta_y = (l, u) => {
  return calc.floor((l - u - 1) / 2.0)
}

#let delta_x = (l, u) => {
  return calc.ceil((l - u - 1) / 2.0) - 1
}

#example[
  Xét hai sự kiện $A, B$ với $a = ((A, B), [2, 4]_8)$ như ở @cons_example, với $pi_A, pi_B$ là hai tiềm năng sự kiện. Chọn $l = 2, u = -4$, ta có:
  $
    delta(2, -4) &= 2 - (-4) - 1 = 5\
    delta y(2, 4) &= floor(frac(delta(2, -4), 2)) = 2\
    delta x(2, 4) &= ceil(frac(delta(2, -4), 2)) - 1 = 2
  $
  được minh họa như @order_rect_szie.
]

#figure(
  cetz.canvas({
    import cetz.draw: *
    set-style(
      stroke: 0.4pt,
      mark: (
        transform-shape: false,
        fill: black,
      ),
    )
    // vars
    let T = 8
    let width = 8
    let height = 8
    let a = 2
    let b = 4
    import cetz.draw: *
    set-style(
      stroke: 0.4pt,
      mark: (
        transform-shape: false,
        fill: black,
      ),
    )


    // Trục tọa độ
    grid((0, 0), (width - 1, height - 1), step: 1, stroke: gray + 0.2pt)
    line((0, 0), (width, 0), mark: (end: "stealth"))
    line((0, 0), (0, height), mark: (end: "stealth"))

    // tick
    let x = 0
    while x < width {
      line((x, -1pt), (x, 1pt))
      line((-1pt, x), (1pt, x))
      x += 1
    }

    // text ab, 3, 5, 8
    content((width, -0.5), $pi_A$)
    content((-0.25, -0.25), $0$)
    content((-0.5, height), $pi_B$)

    let fill-color = color.mix((blue, 40%), white).opacify(-40%)
    line(
      (0, a),
      (0, b),
      (T - 1 - b, T - 1),
      (T - 1 - a, T - 1),
      (0, a),
      fill: fill-color,
      stroke: fill-color.darken(20%),
    )
    line(
      (T - b, 0),
      (T - a, 0),
      (T - 1, a - 1),
      (T - 1, b - 1),
      (T - b, 0),
      fill: fill-color,
      stroke: fill-color.darken(20%),
    )


    let i = 0
    let j = 0
    while i < width {
      j = 0
      while j < height {
        if (j - i >= a and j - i <= b) {
          circle((i, j), radius: 1pt, fill: color.mix((blue, 100%)))


        }

        if (j - i >= a - T and j - i <= b - T) {
          circle((i, j), radius: 1pt, fill: color.mix((blue, 100%)))
        }


        j += 1
      }
      i += 1
    }

    content((-0.5, a), $#a$)
    content((-0.5, b), $#b$)
    content((T - b, -0.5), $#(T - b)$)
    content((T - a, -0.5), $#(T - a)$)
    content((T - 1, -0.5), $#(T - 1)$)
    content((-0.5, T - 1), $#(T - 1)$)


    let error-color = color.mix((red, 70%), white).opacify(-40%)
    rect((3, 2), (5, 4), fill: error-color, stroke: error-color.darken(40%))

    line((3, 0), (3, 2), stroke: (dash: "dashed", paint: red))
    line((5, 0), (5, 2), stroke: (dash: "dashed", paint: red))
    line((0, 2), (3, 2), stroke: (dash: "dashed", paint: red))
    line((0, 4), (3, 4), stroke: (dash: "dashed", paint: red))

    for i in (3, 4, 5) {
      for j in (2, 3, 4) {
        circle((i, j), radius: 1pt, fill: color.mix((red, 100%)))
      }
    }

    line((5.25, 2), (5.25, 4), mark: (end: "stealth", start: "stealth"))
    content((5.5, 3), $delta y$)

    line((3, 4.25), (5, 4.25), mark: (end: "stealth", start: "stealth"))
    content((4, 4.5), $delta x$)


  }),
  caption: [Minh họa vùng xác định kích thước vùng không thỏa mãn],
) <order_rect_szie>


#definition[
  Cho $u, l in ZZ$ với $u < l$ và $t_T in NN$. Khi đó
  $
    phi_t_T: ZZ times ZZ &-> 2^(2^ZZ times 2^ZZ)\
    (l, u) &|-> {
      ([x, x + delta x (l, u)] times [y, y + delta y(l, u)])| \
      &forall y in [-delta y(l, u), t_T - 1]:\
      &x = y - u - 1 - delta x(l, u)
    }\
    &x + delta x(l, u) >= 0 and x <= t_T - 1
  $ là ánh xạ tới tập hợp hình chữ nhật giữa $u $ và $l$.
] <generator>

Áp dụng @generator với hai sự kiện $A, B$, $a = ((A, B), [2, 4]_8)$ như ở @cons_example, với $pi_A, pi_B$ là hai tiềm năng sự kiện. Chọn $l = 2, u = -4$, ta thấy tập hợp các hình chữ nhật hoàn toàn phủ vùng vô nghiệm trong khoảng $(-4, 2)$, được minh họa ở @order_rect

#let unfeasible = (l, u, T) => {
  let d_y = delta_y(l, u)
  let d_x = delta_x(l, u)

  let result = ()
  for y in range(-d_y, T - 1) {
    let x = y - u - 1 - d_x
    if x + d_x >= 0 and x <= T - 1 {
      result.push((x, x + d_x, y, y + d_y))
    }
  }

  result
}

#let render_rect = result => {
  result.chunks(3).map(sub => $&#(sub.map(((x1, x2, y1, y2)) => $([#x1, #x2] times [#y1, #y2])$).join(","))$).join(
    linebreak(),
  )
}

$
  phi_t_T (2, -4) = {#render_rect(unfeasible(2, -4, 8))}
$

#figure(
  cetz.canvas({
    import cetz.draw: *
    set-style(
      stroke: 0.4pt,
      mark: (
        transform-shape: false,
        fill: black,
      ),
    )
    // vars
    let T = 8
    let width = 8
    let height = 8
    let a = 2
    let b = 4
    import cetz.draw: *
    set-style(
      stroke: 0.4pt,
      mark: (
        transform-shape: false,
        fill: black,
      ),
    )


    // Trục tọa độ
    grid((0, 0), (width - 1, height - 1), step: 1, stroke: gray + 0.2pt)
    line((0, 0), (width, 0), mark: (end: "stealth"))
    line((0, 0), (0, height), mark: (end: "stealth"))

    // tick
    let x = 0
    while x < width {
      line((x, -1pt), (x, 1pt))
      line((-1pt, x), (1pt, x))
      x += 1
    }

    // text ab, 3, 5, 8
    content((width, -0.5), $pi_A$)
    content((-0.25, -0.25), $0$)
    content((-0.5, height), $pi_B$)

    let fill-color = color.mix((blue, 40%), white).opacify(-40%)
    line(
      (0, a),
      (0, b),
      (T - 1 - b, T - 1),
      (T - 1 - a, T - 1),
      (0, a),
      fill: fill-color,
      stroke: fill-color.darken(20%),
    )
    line(
      (T - b, 0),
      (T - a, 0),
      (T - 1, a - 1),
      (T - 1, b - 1),
      (T - b, 0),
      fill: fill-color,
      stroke: fill-color.darken(20%),
    )


    let i = 0
    let j = 0
    while i < width {
      j = 0
      while j < height {
        if (j - i >= a and j - i <= b) {
          circle((i, j), radius: 1pt, fill: color.mix((blue, 100%)))


        }

        if (j - i >= a - T and j - i <= b - T) {
          circle((i, j), radius: 1pt, fill: color.mix((blue, 100%)))
        }


        j += 1
      }
      i += 1
    }

    content((-0.5, a), $#a$)
    content((-0.5, b), $#b$)
    content((T - b, -0.5), $#(T - b)$)
    content((T - a, -0.5), $#(T - a)$)
    content((T - 1, -0.5), $#(T - 1)$)
    content((-0.5, T - 1), $#(T - 1)$)

    let rects = unfeasible(2, -4, T)
    let error-color = color.mix((red, 70%), white).opacify(-40%)

    for (x1, x2, y1, y2) in rects {
      rect((x1, y1), (x2, y2), fill: error-color, stroke: error-color.darken(40%))
      for i in range(x1, x2 + 1) {
        for j in range(y1, y2 + 1) {
          circle((i, j), radius: 1pt, fill: color.mix((red, 100%)))
        }
      }
    }

    line((-1, 1), (6, 8))
    // content((3, 4), $pi_B - pi_A < 2 $, angle: 45deg)
    line((3, -1), (8, 4))
    // content((5, 2), $pi_B - pi_A > 4 - t_T = -4 $, angle: 45deg)

    // for y in range(-)


  }),
  caption: [Minh họa tập hợp hình chữ nhật phủ vùng vô nghiệm $((A, B), [2, 4]_8)$],
) <order_rect>

Tương tự, ta cần phủ hai vùng vô nghiệm còn lại ở góc trái trên và góc phải, tương ứng với các khoảng $(4, 8), (-8, -6)$. Từ đó
ta có công thức tổng quát cho ràng buộc thời gian $((A, B), [l, u]_t_T)$

#definition[
  Cho ràng buộc thời gian $a = ((A, B), [l, u]_t_T)$. Với
  $
    k = -1 &"nếu" 0 in [l, u]_t_T\
    k = 0 &"nếu" 0 in.not [l, u]_t_T
  $

  $
    zeta_t_T: ZZ times ZZ &-> 2^((ZZ times ZZ) times (ZZ times ZZ))\
    (l, u) &|-> union.big_(i in [k, 1]) phi_t_T (l + i dot t_T, u + (i - 1) dot t_T)
  $ là hàm số sinh tất cả các hình chữ nhật phủ miền vô nghiệm của $a$
]


Tiếp theo, ta cần mã hóa các hình chữ nhật này thành các mệnh đề chuẩn tắc. Điều này có thể tổng quát trực tiếp từ @cons_example. Từ đó ta có ánh xạ tổng quát ràng buộc thời gian thành các mệnh đề chuẩn tắc.

#definition[
  Cho $A = ([x_1, x_2] times [y_1, y_2]) in 2^ZZ times 2^ZZ$ với $(x, y) in A$. Khi đó
  $
    "encode_order_rect": 2^ZZ times 2^ZZ &-> Sigma_("SAT")\
    [x_1, x_2] times [y_1, y_2] &|-> (not p_(x, x_2) or p_(x, x_1 - 1) or not p_(y, y_2) or p (y, y_1 - 1))
  $ là mã hóa thứ tự loại trừ miền phủ bởi $A$, trong đó $p_(l, k)$ là các biến logic tương ứng với mệnh đề $l <= k$ ở @ahihi
]


#definition[
  Cho ràng buộc thời gian $a = ((A, B), [l, u]_t_T)$. Khi đó
  $
    "encode_order_time_con": C &-> L(Sigma_"SAT")\
    ((A, B), [l, u]_t_T) &|-> and.big_(A in zeta_t_T (l, u)) "encode_order_rect"(A)
  $ là hàm số mã hóa thứ tự ràng buộc thời gian
]

*Mã hóa thứ tự ràng buộc đối xứng*

Mã hóa ràng buộc đối xứng hoàn toàn tương tự với ràng buộc thời gian. Ta dễ dàng có được các kết quả sau:

#definition[
  Cho $u, l in ZZ, u < l$ và $t_T in NN$. Khi đó

  $
    psi_t_T : ZZ times ZZ -> &2^(2^ZZ times 2^ZZ)\
    (l, u) |-> &{
      ([x, x + delta x(l, u)] times [y, y + delta y(l, u)]) \
      &forall y in [-delta y, t_T - 1]:\
      &x = -y + l - 1 - delta x(l, u)
    }
  $ là hàm số ánh xạ tất cả hình chữ nhật giữa $u$ và $l$
]


#definition[
  Cho ràng buộc thời gian $a = ((A, B), [l, u]_t_T)$. Với
  $
    k = 1 &"nếu" 0 in [l, u]_t_T\
    k = 2 &"nếu" 0 in.not [l, u]_t_T
  $

  $
    Lambda_t_T: ZZ times ZZ &-> 2^((ZZ times ZZ) times (ZZ times ZZ))\
    (l, u) &|-> union.big_(i in [0, k]) phi_t_T (l + i dot t_T, u + (i - 1) dot t_T)
  $ là hàm số sinh tất cả các hình chữ nhật phủ miền vô nghiệm của $a$
]


#definition[
  Cho ràng buộc đối xứng $a = ((A, B), [l, u]_t_T)$. Khi đó
  $
    "encode_order_sym_con": S &-> L(Sigma_"SAT")\
    ((A, B), [l, u]_t_T) &|-> and.big_(A in Lambda_t_T (l, u)) "encode_order_rect"(A)
  $ là hàm số mã hóa thứ tự ràng buộc đối xứng
]

Với toàn bộ thông tin từ các phần trước, ta có hàm số mã hóa thứ tự toàn bộ bài toán PESP như sau:

#definition[
    Cho $A = S union C$ là tập hợp các ràng buộc ở @cons_def, khi đó:
    $
      "encode_order_con": A &-> L(Sigma_"SAT") \
      a &|->  cases("encode_order_time_con"(a) "nếu" a in C, "encode_order_sym_con"(a) "nếu" a in S)
    $
]


#definition[
    Cho $A = S union C$ là tập hợp các ràng buộc ở @cons_def, khi đó:
    $
      Psi^A_"order" = and.big_(a in A) "encode_order_con"(a)
    $
]


#definition[
    Cho $N = (nu, A, t_T)$ là mạng sự kiện định kỳ như đã định nghĩa ở @cons_def, khi đó:
    $
      "encode_direct_pesp": 2^(nu^+) times 2^(A^+_t_T) times 2^NN &-> L(Sigma_"SAT")\

      (nu, A, t_T) &|-> (Omega_"order"^nu and Psi^A_"order")
    $ là hàm số mã hóa thứ tự của mạng định kỳ $N$.
]

== So sánh mã hóa trực tiếp và mã hóa thứ tự

Trong chương này khóa luận sẽ so sánh hai phương pháp mã hóa trực tiếp và thứ tự ở các thông số như số mệnh đề và số biến. Các thông số khác như thời gian giải thực tế sẽ được trình bày ở @exp. Để thuận tiện, ta định nghĩa thêm một số khái niệm sau.

#definition[
  Cho $F in L(Sigma_"SAT")$ là một biểu thức chuẩn tắc hội. Khi đó:
  $
    abs(F) in NN
  $ là số mệnh đề (số tuyển sơ cấp) của F.
]


#definition[
  Cho $F in L(Sigma_"SAT")$ là một biểu thức chuẩn tắc hội. Khi đó:
  $
    abs("vars"(F)) in NN
  $ là số biến được sử dụng trong F.
]


=== Số biến

Với $F$ là biểu thức chuẩn tắc hội sinh ra từ mã hóa trực tiếp của mạng định kỳ $N = (nu, A, t_T)$. Từ @def_direct ta thấy với mỗi tiềm năng $pi_n (n in nu)$, ta cần $t_T$ biến vì $pi_n in [0, t_T - 1]$. Do đó

$
  |"vars"("encode_direct_pesp"(N))| = |"vars"(F)| = t_T dot |nu|
$ tức là số biến bằng tích của chu kỳ và số sự kiện.

Tương tự ta xem xét $G$ là biểu thức chuẩn tắc hội sinh từ mã hóa thứ tự của mạng định kỳ $N = (nu, A, t_T)$. Từ @ahihi


$
  |"vars"("encode_order_pesp"(N))| = |"vars"(G)| = (t_T - 1) dot |nu|
$

Trong thực tế, chu kì $t_T = 60$ hoặc $t_T = 120$. Vì vậy sự khác biệt về số biến là không lớn.

$
  |"vars"("encode_direct_pesp"(N))| approx |"vars"("encode_order_pesp"(N))|
$

=== Số mệnh đề

Để ước tính số mệnh đề sử dụng, ta cần ước tính lần lượt số mệnh đề dùng cho mã hóa tiềm năng và số biến mã hóa ràng buộc, $Omega_t^nu$ và $Psi_t^A t in {"direct", "order"}$. Dễ thấy

$
  abs(Omega_t^nu and Psi_t^A) = abs(Omega_t^nu) + abs(Omega_t^nu) \ t in {"direct", "order"}
$

Đầu tiên, với mã hóa biến $Omega_t^nu$, do các biến có cùng tập xác định $[0, t_T - 1]$.

$
  abs(Omega_t^nu) = abs(nu) dot abs("encode_direct"(pi_n))\
  abs(Omega_t^nu) = abs(nu) dot abs("encode_order"(pi_n))\
  n in nu
$ <thing_1>

Từ các kết quả ở @encoding, ta có:

$
  abs("encode_direct"(pi_n)) &= frac(abs([0, t_T - 1]) dot (abs([0, t_T - 1]) - 1), 2)\
  &= frac(t_T dot (t_T - 1), 2)\


  abs("encode_order"(pi_n)) &= abs([0, t_T - 1]) - 2\
  &= t_T - 2
$ <thing_2>

Từ @thing_1 và @thing_2 kết hợp với kí pháp $O(n)$, ta có:

$
  abs(Omega_"direct"^nu) &in O(t^2 abs(nu))\
  abs(Omega_"order"^nu) &in O(t abs(nu))
$ <vars_thing>

Tiếp theo, ta cần xem xét mã hóa các ràng buộc $Psi_t^A t$. Do mã hóa trực tiếp loại trừ các cặp không thỏa mãn $P_a$ nên ta có:

$
  abs(Psi^A_"direct") = sum_(a in A) abs(P_a)
$

Hiển nhiên $abs(P_a) in O(t^2_T)$ do $forall (i, j) in P_a => (i, j) in [0, t_T - 1] times [0, t_T - 1]$. Do đó

$
  abs(Psi^A_"direct") in O(t^2_T abs(A))
$ <cons_thign1>

Với mã hóa thứ tự, mỗi ràng buộc chỉ cần hợp của 2 hoặc 3 lần (tùy theo $[l, u]$) $phi_t_T$, mà $phi_t_T$ tỉ lệ với $[-delta y, t_T - 1]$ theo như @generator. Do vậy


$
  abs(Psi^A_"order") in O(t_T abs(A))
$ <cons_thign2>

Kết hợp @vars_thing, @cons_thign1 và @cons_thign2 ta có:

$
  |"vars"("encode_direct_pesp"(N))| in O(t^2(abs(nu) + abs(A)))\
  |"vars"("encode_order_pesp"(N))| in O(t_T (abs(nu) + abs(A)))
$

Từ kết quả này ta thấy mã hóa thứ tự nhanh gấp $t_T$ lần so với mã hóa trực tiếp trên cùng một mạng định kỳ. Kết quả này sẽ được kiểm chứng ở @exp.

#pagebreak(weak: true)

= Thực nghiệm và kết quả <exp>

== Mô hình bài toán PTSP về bài toán PESP

Vấn đề lập lịch tàu chạy (PTSP) trong thực tế còn phức tạp và có nhiều yếu tố tác động. Tuy nhiên, với sai số cho phép, ta có thể chuyển hoá các yêu cầu nghiệp vụ về sự kiện và các ràng buộc trong bài toán PESP.

Ứng với mỗi tàu L và ga $s$, tạo một sự kiện khởi hành và cập bến $L_(t, s) (t in {"dep", "arr"})$. Mỗi sự kiện khởi hành và cập bến phải tuân theo chu kì $t_T$. Giữa hai sự kiện này có một ràng buộc thời gian $(L_("arr", s), L_("dep", s), [l, u]_t_T)$, ràng buộc thời gian tối thiểu và tối đa tàu dừng tại ga $("arrival" -> "departure")$. Tương tự, ta ràng buộc thời gian đi từ gia $s_1 -> s_2$ bằng ràng buộc $(L_("dep", s_1), L_("arr", s_2), [l', u']_t_T)$. $l', u'$ có thể ước lượng từ khoảng cách hai ga và vận tốc của tàu.

Để ngăn hai tàu sử dụng cùng một đường ray, ta giới hạn thời gian đến cùng 1 ga phải cách nhau một thời gian đệm tương đối: $(L_("arr", s), J_("arr", s), [l, u]_t_T)$. Tương tự với các yêu cầu ràng buộc khác.

Ta thu được thời gian biểu chính xác khi giải được bài toán PESP tương ứng.


== Bộ dữ liệu thực nghiệm

Dữ liệu thử nghiệm được thu thập từ #link("https://timpasslib.aalto.fi/pesplib.html", "PESPlib") #footnote[https://timpasslib.aalto.fi/pesplib.html] @pesplib, một tập dữ liệu PESP đã được chuẩn hóa và xử lý nhằm đánh giá hiệu quả của các thuật toán giải PESP. PESPlib được cộng đồng học thuật đánh giá cao và được dùng làm tiêu chuẩn đánh giá trong nhiều nghiên cứu @pesplib_ref_1@pesplib_ref_2.
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

Toàn bộ dữ liệu đầu vào gồm 18 file với độ khó tăng dần, định dạng như mô tả ở trên. Thông qua tiền xử lý sơ bộ, ta có thông tin cơ bản của dữ liệu đầu vào như sau:

#let results = csv("image/input_instances.csv")

#figure(
  table(
    columns: (1fr, 1fr, 1fr, 1fr),
    ..results.flatten(),
  ),
  caption: "Bảng mô tả độ phức tạp của dữ liệu PESP đầu vào",
)


== Kết quả và đánh giá


Để tiến hành thử nghiệm hai phương pháp đã nêu ở @pesp_reduction, khoá luận đã cài đặt một công cụ dòng lệnh giải bài toán PESP có tên là #link("https://github.com/ppvan/pesp-sat", "pesp-sat")#footnote[https://github.com/ppvan/pesp-sat] <repo>.

Chương trình thử nghiệm được cài đặt bằng ngôn ngữ Go, sử dụng bộ giải SAT #link("https://github.com/go-air/gini", "Gini") #footnote[https://github.com/go-air/gini]. Công cụ hỗ trợ đa nền tảng, được kiểm thử kĩ lưỡng, độ bao phủ đạt 80%, mã nguồn lưu tại: #link("https://github.com/ppvan/pesp-sat", "ppvan/pesp-sat") #footnote(<repo>). Tất cả tài liệu và dữ liệu liên quan, bao gồm mã nguồn công cụ thử nghiệm, tài liệu khóa luận và slide trình bày khóa luận được lưu trữ tại git repo này.

Để kiểm chứng chương trình thử nghiệm, vui lòng làm theo hướng dẫn trong README.md. Thực nghiệm sau đây được tiến hành trên máy tính (laptop) sau:

#figure(
  table(
    columns: (auto, 12em),
    [*Component*], [*Details*],
    [CPU], [AMD Ryzen™ 7 7735H],
    [RAM], [32GB DDR4],
    [Disk], [512GB SSD NVme],
    [OS], [Linux 6.6.51-1-lts],
    [Gini(bộ giải SAT)], [v1.0.4 - Go 1.23],
  ),
  caption: "Cấu hình máy chạy thực nghiệm",
)


Khóa luận sẽ tiến hành đo thời gian chạy (ms), số mệnh đề, số biến của hai thuật toán mã hóa trình bày ở @pesp_reduction, chi tiết trong @benmark_1. Mỗi ví dụ đều được tính trung bình 10 lần chạy để giảm sai số.

#let benmark = csv("image/benmark.csv")

#figure(
  table(
    columns: 9,
    table.header([], [], [], table.cell([*Direct Encoding*], colspan: 3), table.cell([*Order Encoding*], colspan: 3)),
    [Index], [Events], [Cons], [Vars], [Clauses], [Time], [Vars], [Clauses], [Time],
    ..benmark.flatten(),
  ),
  caption: "Kết quả chạy thử nghiệm, thời gian tính bằng mili giây (ms)",
  placement: top,
) <benmark_1>

#pagebreak()
#figure(image("image/Vars_plot.png"), caption: "Biểu đồ đường so sánh số biến của Direct và Order Encoding")


#figure(image("image/Cons_plot.png"), caption: "Biểu đồ đường so sánh số mệnh đề của Direct và Order Encoding")


#figure(image("image/Time_plot.png"), caption: "Biểu đồ đường so sánh thời gian thực thi của Direct và Order Encoding")

Quan sát bảng dữ liệu và các biểu đồ trên, ta thấy cả hai thuật toán đều tăng độ phức tạp nhất quán với độ phức tạp tăng dần của vấn đề PESP đầu vào. Khoảng cách giữa Direct và Order Encoding là khá rõ rệt (khoảng 7x-50x về thời gian, 15x-20x về số mệnh đề). Tuy nhiên về số biến, hai phương pháp tương đối đồng đều. Như vậy, phương pháp mã hóa Order tỏ ra tương đối ưu việt so với Direct, điều này có thể dễ dàng giải thích bởi Order encoding loại bỏ không gian tìm kiếm theo từng vùng thay vì từng điểm như Direct, dẫn đến số mệnh đề ít hơn. Hơn nữa, theo mô tả ở @pesp_reduction, các mệnh đề Order encoding chồng chéo lên nhau kiến vùng mâu thuẫn được tìm ra nhanh chóng bởi bộ giải SAT.

Với sức mạnh phần cứng hiện tại, cả hai phương pháp đều giải ra khá nhanh (từ 100ms đến 24s) dù số mệnh đề lên đến hàng chục triệu, do giới hạn của dữ liệu đầu vào, ta chưa thống kê được giới hạn của hai giải thuật. Mặt khác, bài toán PESP sinh ra khá nhiều nghiệm thỏa mãn, dẫn đến nhu cầu tìm ra nghiệm tối ưu (bài toán lập lịch tàu chạy tối ưu). Tuy nhiên, việc tìm ra các nhân tố đánh giá lịch trình đang gặp nhiều khó khăn, cần nghiên cứu thêm yêu cầu thực tế và cải thiện mô hình toán học @new_pesp1 @YAN201952, không được trình bày đầy đủ trong khóa luận này. Đây là thiếu sót khóa luận chưa thể khắc phục, cần cải thiện trong tương lai.

== Kết luận

Khoá luận đã trình bày nghiên cứu mới nhất về bài toán lập lịch định kì(PESP) và phương hướng tiếp cận bài toán sử dụng định nghĩa hình thức và các bộ giải SAT. Hai giải thuật mã hóa đã được cài đặt và thực nghiệm nhằm giải các bài toán PESP. Kết quả thực nghiệm cho thấy phương pháp Order Encoding tỏ ra hiệu quả hơn nhiều so với phương pháp còn lại, thách thức nhiều giới hạn trong tương lai.


Quá trình nghiên cứu và thực nghiệm khóa luận đã giúp tôi có điều kiện tìm tòi, suy luận về bài toán lập lịch định kỳ cũng như phương pháp giải nó sử dụng kĩ thuật định nghĩa hình thức và bộ giải SAT. Khóa luận đã cho tôi những tri thức, trải nghiệm tuyệt vời khi nghiên cứu khoa học. Bên cạnh đó, tôi đã tiếp thu được nhiều bài học và phong cách làm việc, nghiên cứu khoa học từ thầy hướng dẫn.

Trên đây là toàn bộ nghiên cứu của tôi trong thời gian qua, tài liệu khó tránh khỏi sai sót, mong nhận được sự góp ý của các thầy cô và các bạn nghiên cứu về SAT, giúp tôi có thể hoàn thiện hơn nữa trong tương lai.

#pagebreak()

#show heading.where(depth: 1): it => pad(text(it.body, size: 24pt), x: 0pt, y: 40pt)

#set heading(numbering: none)
#counter(heading).update(100)


#set text(lang: "en")
#bibliography("citation.bib", title: "Tài liệu tham khảo") <citation>