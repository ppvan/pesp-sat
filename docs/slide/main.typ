#import "@preview/polylux:0.3.1": *
#import "custom.typ": *
#import "@preview/fletcher:0.5.1" as fletcher: diagram, node, edge
#import "@preview/cetz:0.2.1"

#set text(font: "")


#let delta_y = (l, u) => {
  return calc.floor((l - u - 1) / 2.0)
}

#let delta_x = (l, u) => {
  return calc.ceil((l - u - 1) / 2.0) - 1
}


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
  // #set text(size: 12pt)
  #set figure(supplement: "")
  == Bài toán lập lịch tàu điện
  #side-by-side[
    #figure(image("../image/tokyo.jpg", height: 10em, width: 8em), caption: "Nhật")
  ][
    #figure(image("../image/gemany.jpg", height: 10em, width: 8em), caption: "Đức")
  ][
    #figure(image("../image/vn.jpg", height: 10em, width: 8em), caption: "Việt Nam")
  ]
]


#slide[
  #counter(heading).update(1)
  == Bài toán lập lịch tàu điện

  #side-by-side[
    - Thời gian hồi phục
    - Tính kết nối
    - Thời gian bảo dưỡng cuối trạm
    - Thời gian giãn cách tối thiểu
  ][
    #image("../image/placeholder2.png")
  ]
]

#slide[
  #counter(heading).update(1)
  == Bài toán lập lịch tàu điện

  #side-by-side[
    - Thời gian hồi phục
    - Tính kết nối
    - Thời gian bảo dưỡng cuối trạm
    - Thời gian giãn cách tối thiểu
  ][
    #image("../image/placeholder2.png")
  ]
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

  Tất cả phương pháp giải _thỏa mãn ràng buộc_ đều có thể giải bài toán PESP.

  - Thuật toán quay lui
  - Local Search
  - Quy hoạch số nguyên (Mixed Integer Programming)

]


#slide[
  == Hạn chế

  #side-by-side[
    Độ phức tạp thời gian cao, không thể giải những bài toán đủ khó đáp ứng nhu cầu thực tế.
  ][
    #image("../image/bigo.png")
  ]
]


#slide[
  #counter(heading).update(2)
  == Tiến bộ của SAT Solver
  #side-by-side[

    SAT Solver hiện tại đã giải được bài toán hàng triệu mệnh đề.

    - Social Golfer Problem
    - Nurse Scheduling Problem
    - Course Scheduling Problem
  ][
    #image("../image/sat_improvement.png")
  ]
]


#slide[
  == Phương pháp giải bài toán PESP sử dụng SAT Solver
  #diagram(
    spacing: 2em,
    node-stroke: 1pt,
    // node-inset: 8pt,
    node-corner-radius: 4pt,
    {
      let nodes = ((0, 0), (1, 0), (2, 0))

      node((1, 0), [1. $N = (nu, A, t_T)$])
      node((2, 0), [2. $"encode"(nu, A, t_T)$])
      node((3, 0), [3. $"SAT Solver"$])
      node((3, -1), [4.2 $"No schedule"$])
      node((3, 2), [4.1 $"Interpretation" I$])
      node((1, 2), [5. $"Schedule" Pi_v$])


      edge((1, 0), (2, 0), "->")

      edge((2, 0), (3, 0), "->")
      edge((3, 0), (3, -1), "->", [UNSAT])
      edge((3, 0), (3, 2), "->", [SAT])
      edge((3, 2), (1, 2), "->", [Decode (I)])
    },
  )
]


#slide[
  == Giải bài toán PESP sử dụng SAT Solver

  #grid(
    columns: (1fr, 1fr),
    align: (left, right),
    [
      *Mã hóa trực tiếp*

      Sinh ra mệnh đề loại tất cả điểm không thỏa mãn.

      $
        a = (A, B, [2, 4]_8)
      $

      #sym.arrow Cần chiến lược tốt hơn để loại vùng không thỏa mãn
    ],
    [
      #cetz.canvas({
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
            } else if (j - i >= a - T and j - i <= b - T) {
              circle((i, j), radius: 1pt, fill: color.mix((blue, 100%)))
            } else {
              circle((i, j), radius: 2pt, fill: color.mix((red, 100%)))
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

    ],
  )
]


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

#slide[
  == Giải bài toán PESP sử dụng SAT Solver

  #side-by-side[
    *Mã hóa thứ tự*

    Sinh ra mệnh đề loại tất cả các hình chữ nhật.

    $
      a = (A, B, [2, 4]_8)
    $

    #sym.arrow Hình chữ nhật dễ mô tả trong không gian logic
  ][
    #set align(right)
    #cetz.canvas({
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
    })
  ]

  #uncover(1)[
    #set align(center + horizon)
    #cetz.canvas({
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
    })
  ]
]


#slide[
  #counter(heading).update(3)
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

  #image("../image/placeholder.png")
]


#slide[
  == Kết quả thực nghiệm

  #image("../image/placeholder.png")
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