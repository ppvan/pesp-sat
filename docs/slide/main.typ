#import "@preview/polylux:0.3.1": *
#import "custom.typ": *
#import "@preview/fletcher:0.5.1" as fletcher: diagram, node, edge

#set text(font: "")


#show: simple-theme.with(footer: context [
  Trường Đại học Công nghệ - ĐHQGHN
])

#let author = "Phạm Văn Phúc"
#let title = "Nghiên cứu bài toán PESP áp dụng để lập lịch giờ tàu điện chạy"
#let class = "K66-CC"
#let advisor = "TS. Tô Văn Khánh"
#let major = "Công nghệ thông tin"

#title-slide[
  = Giải bài toán PESP ứng dụng trong lập lịch tàu chạy bằng phương pháp SAT
  #v(1em)
  #set text(size: 20pt)
  #line(length: 40%)
  #v(1em)


  #grid(
    columns: (auto, auto),
    align: (left, left),
    column-gutter: 1em,
    row-gutter: 1em,
    "Sinh viên", author,
    "Giảng viên hướng dẫn", advisor,
    "Lớp", class,
    "Ngành", major,
  )
  #align(center + bottom, [#datetime.today().display("[month] - [year]")])


]

#slide[

  == Nội dung chính

  #align(
    center + top,
    grid(
      columns: (1fr),
      align: (left+horizon, left+horizon),
    //   rows: (1fr, 1fr),
      row-gutter: 2em,
      column-gutter: 2em,
      [1. Giới thiệu & Đặt vấn đề], [2. Giải pháp cải tiến],
      [3. Thực nghiệm & Đánh giá], [4. Kết luận],
    ),
  )
]

#set heading(numbering: "1.1")

#slide[
  #counter(heading).update(1)
  == Bài toán lập lịch tàu điện
  Lịch trình cần đáp ứng nhiều yêu cầu:
  - Thời gian hồi phục: Cho phép một khoảng delay bù đắp cho nhưng delay nhỏ khắp hệ thống.
  - Tính kết nối: Hai tàu cần dừng ở trạm trong khoảng thời gian đủ lâu nhằm phục vụ nhu cầu nối chuyến
  - Thời gian bảo dưỡng cuối trạm: Tàu điện cần được kiểm tra, bảo dưỡng, thay ca nhân viên trước khi khởi hành chuyến tiếp theo.
  - Thời gian giãn cách tối thiểu: Hai tàu dùng chung tuyến đường cần có lịch trình cách nhau một khoảng thời gian tối thiểu vì lí do an toàn.
]


#slide[
  #counter(heading).update(1)
  == Bài toán lập lịch tàu điện
  Lịch trình cần tối ưu thêm các thông số:
  - Tối thiểu thời gian di chuyển
  - Tính ổn định
  - Tính linh hoạt
]


#slide[
  #counter(heading).update(2)
  == Mô hình PESP

  #side-by-side[PESP#footnote[Periodic Event Scheduling Problem] được giới thiệu bởi Serafini và Ukovich, nhằm giải quyết bài toán lập lịch tuần hoàn.
    #v(0.5em)
    /*
     * Mô hình PESP ràng buộc các sự kiện phải xảy ra trong nhưng giới hạn nhất định nhằm mô tả các yêu cầu nghiệp vụ.
     * Ví dụ: Hàng khách cần chuyển từ tàu A sang B?
     * Sự kiện B khởi hành và A khởi hành phải trong khoảng từ 5 đến 15 phút.
     * Thời gian bảo dưỡng cuối trạm?
     * Sự kiện tàu B dừng tại trạm Z - Sự kiện tàu B khởi hành phải trong khoảng 0 đến 10 phút
     */

    - $pi_B - pi_A in [5, 15]_60$
    - $pi_C - pi_A in [0, 10]_60$

    #v(0.5em)
    #set text(size: 16pt)
    $[5, 15]_60 = ... union [-55, -45] union [5, 15] union [65, 75] union ...$

  ][
    #diagram(
      spacing: 6em,
      {
        let (a, b, c) = ((-1 / calc.sqrt(3), 0), (0, -1), (1 / calc.sqrt(3), 0))
        node(a, $A$, stroke: 1pt)
        node(b, $B$, stroke: 1pt)
        node(c, $C$, stroke: 1pt)
        edge(a, b, "->", $[5, 15]_60$)
        edge(b, c, "->", $[0, 10]_60$)
        edge(a, c, "->", $[0, 5]_60$)
      },
    )
  ]
]


#slide[
  #counter(heading).update(2)
  == Mô hình PESP

  #side-by-side[
    PESP thuộc lớp bài toán _thỏa mãn ràng buộc_#footnote[Constraint satisfaction problem].

    Được chứng minh là bài toán _NP-hard_#footnote[M. A. Odijk, Construction of Periodic Timetables. Pt. 1. A Cutting Plane
Algorithm. TU Delft, 1994]
  ][
    #diagram(
      spacing: 6em,
      {
        let (a, b, c) = ((-1 / calc.sqrt(3), 0), (0, -1), (1 / calc.sqrt(3), 0))
        node(a, $A$, stroke: 1pt)
        node(b, $B$, stroke: 1pt)
        node(c, $C$, stroke: 1pt)
        edge(a, b, "->", $[5, 15]_60$)
        edge(b, c, "->", $[0, 10]_60$)
        edge(a, c, "->", $[0, 5]_60$)
      },
    )
  ]
]


#slide[
  == Giải pháp hiện tại
  Quy hoạch số nguyên (Mixed Integer Programming)

]


#slide[
  == Hạn chế
  Khá chậm, không thể giải những hệ thống lớn và phức tạp
]


#slide[
  #counter(heading).update(2)
  == Tiến bộ của SAT Solver
  #side-by-side[
    #lorem(7)
  ][
    #lorem(7)
  ]
]


#slide[
  == Phương pháp giải bài toán PESP sử dụng SAT Solver
  #side-by-side[
    #lorem(7)
  ][
    #lorem(7)
  ]
]


#slide[
  == Phương pháp giải bài toán PESP sử dụng SAT Solver
  #side-by-side[
    #lorem(7)
  ][
    #lorem(7)
  ]
]


#slide[
  #counter(heading).update(3)
  == Thực nghiệm, đánh giá
  #side-by-side[
    #lorem(7)
  ][
    #lorem(7)
  ]
]



#slide[
  == Dữ liệu thực nghiệm

  PESPlib#footnote[https://timpasslib.aalto.fi/]:
  - 22 file dữ liệu được chuẩn hóa
  - Được sử dụng trong nhiều nghiên cứu #footnote[M. Goerigk and A. Schöbel, “An empirical analysis of robustness concepts
for timetabling,” Erlebach, vol. 14, pp. 100–113, 2010] #footnote[
  J.-W. Goossens, “Models and algorithms for railway line planning prob-
lems,” p. , 2004.
]
]


#slide[
  == Kết quả thực nghiệm
  #lorem(7)
]


#slide[
  #counter(heading).update(4)
  #set heading(numbering: none)
  = Kết luận
  #v(2em)
  - Cùng với sự tiến bộ của SAT Solver, ta có thể giải các bài toán PESP phức tạp trong một khoảng thời gian hợp lý.
  - Phương pháp vẫn tiếp được cải tiến bởi nhiều nghiên cứu.
]

// https://www.zib.de/userpage/lindner/concurrent-pesp-talk-norrk%C3%B6ping.pdf

#centered-slide()[
  Trân trọng cảm ơn thầy cô đã lắng nghe
]