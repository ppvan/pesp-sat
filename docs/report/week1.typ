
#set align(center)
#set text(font: "Roboto Serif", size: 12.5pt)

#upper(text("Đại học quốc gia Hà Nội", size: 20pt))

#upper(text("Trường đại học công nghệ", size: 16pt))

#pad(align(image("../image/Logo_HUET.svg", fit: "contain", width: 30%), center), y: 20%)

#pad(align(center+top)[#text("PESP SAT Encoding", size: 16pt)], y: 40%)

#pad(
  y: 30%,
  block(width: 100%, grid(columns: (auto, auto), rows: 4, column-gutter: 24pt, row-gutter: 12pt, align: left+horizon, "Giảng viên hướng dẫn:", "TS. Tô Văn Khánh", "Sinh viên:", "Phạm Văn Phúc", "Mã sinh viên:", "21020782", "Lớp:", "QH-2022-I/CQ-C-C"))
)


#align(center+bottom)[Hà Nội - 2024]


#pagebreak(weak: true)

#set page(
  paper: "a4",
)
#set align(left)
#set par(justify: true)
#set text(font: "Roboto Serif", size: 12pt, overhang: false)
#set page(numbering: "1")
#set heading(numbering: "1")

#show heading.where(
  level: 2
): it => block(width: 100%)[
  #set align(left)
  #set text(16pt, weight: "regular")
  #pad(block(smallcaps(it.body)), y: 12pt)
]

#show heading.where(
  level: 3
): it => block(width: 100%)[
  #set align(left)
  #set text(14pt, weight: "regular")
  #pad(block(smallcaps(it.body)), y: 6pt)
]


== Bài toán lập lịch trình tàu (POSP)

=== Mô tả

Bài toán lập lịch (Timetabling) là một trong những bài toán quan trọng trong việc xây dựng hệ thống tàu công cộng. Bảng lịch trình là nguồn thông tin cô đọng và hữu ích với cả nhân viên và hành khách, dễ nhớ và dự đoán. Một lịch trình tốt làm tăng tính tin cậy, giảm chi phí vận hành, tăng trải nghiệm di chuyển...

Tuy nhiên, lập lịch trình là công việc tốn nhiều thời gian, công sức và tiền bạc. Bên cạnh đó độ chính xác của việc lập lịch thủ công là không cao. Với các hệ thống lớn và phức tạp hiện nay, lập lịch trình thủ công là không khả thi. Vì vậy đã có nhiều nghiên cứu nhằm tự động hóa việc lập trình trình tàu.


=== Yêu cầu nghiệp vụ <req>

Khi lập lịch trình cho hệ thống tàu, ta cần lưu ý các ràng buộc sau:

- _Thời gian di chuyển_ (Traveling time):
  Thời gian di chuyển giữa các bến. Với thông số kĩ thuật cho trước, ta có thể dự đoán vận tốc cũng như giới hạn khoảng thời gian di chuyển giữa các bến. Trước khi lên lịch trình, ta cần biết khoảng giới hạn của thời gian này.

- _Thời gian chờ bến_ (Dwelling at stations):
  Thời gian dừng ở bến nhằm đón/trả hành khách

- Thời gian giãn cách tối thiểu:
  Thời gian khởi hành của hai tàu sử dụng chung một tuyến đường cần có giới hạn dưới nhất định vì lí do an toàn.

- Tính kết nối (Connections between trains):
  Cần có một khoảng giao nhất định giữa thời gian dừng ở bến của các tàu dừng ở cùng một bến nhằm phục vụ khách hàng di chuyển nối chuyến.

- Thời gian nghỉ ở trạm cuối:
  Thời gian này có thể dùng để sửa chữa, đổi nhân viên... Cần ràng buộc thời gian này ở một khoảng nhất định, để có đủ thời gian bảo trì cũng như không quá lâu để tránh có một tàu khác đến cuối trạm.


=== [Mở rộng] Bài toán lập lịch tàu tối ưu (POTP)

== Phương pháp giải

=== Mô hình sự kiện có chu kì (PESP)

Periodic Event Scheduling Problem (PESP) là một mô hình nhằm giải các bài toán lập lịch có chu kỳ (ví dụ như lập lịch trình tàu).

Mô hình đưa ra khái niệm sự kiện, chu kỳ T và các ràng buộc về khoảng thời gian giữa các sự kiện. Mục tiêu của bài toán là gán các sự kiện vào các mốc thời gian nhất định nhằm thỏa mãn các ràng buộc. Ta thấy PESP có thể mô hình các ràng buộc về thời gian ở
@req


PESP được chứng minh là NP-Complete với $T >= 3$

==== Khái niệm

Khoảng (Interval): Cho $a, b in Z.$ Định nghĩa: 
$ [a, b] = {a, a +1, ..., b - 1, b} $

Khoảng đồng dư $T$ (Interval modulo $t$): Cho $a, b in ZZ, t in NN^+$

$ [a, b]_t = union_(z in ZZ) [a + z t, b + z t] $




#lorem(30)



=== PESP Solver

#lorem(30)

=== Solve PESP with SAT

#lorem(30)

=== Comparision

#lorem(30)