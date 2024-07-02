
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

$ [a, b]_t = union.big_(z in ZZ) [a + z t, b + z t] $

Mạng sự kiện chu kỳ (Periodic Event Network): Một mạng sự kiện chu kỳ $Nu = (nu, A, t_T)$ bao gồm: $nu$ sự kiện,  chu kì $t_T$ và tập hợp các ràng buộc $a in A$:

$ a = ((i, j), [l_a, u_a]_(t_T)) in (nu times nu) times 2^ZZ $

- $a$ ràng buộc giữa hai sự kiện $i "và" j$. Có thể hình dung đây là ràng buộc để có thể đi từ sự kiện $i$ đến sự kiện $j$
- $(i, j)$ sự kiện $i, j$
- $[l_a, u_a]_(t_T)$ khoảng thời gian giới hạn tuân theo chu kì $t_T$ (lower bound and upper bound).

- $(nu times nu) times 2^ZZ$ là tập hợp tất cả khả năng của ràng buộc. Tương tự $n in NN$
- $2^ZZ$ tập hợp tất cả các tập con của Z. Ví dụ: ${1,2,3}, {-1, 0, 10}...$


Có hai loại ràng buộc: ràng buộc thời gian và ràng buộc đối xứng, lần lượt là các tập hợp $S$ và $C$. Ta luôn có $A = S union C$ và $S sect C = emptyset$



Tiềm năng sự kiện(Event potential): Cho $Nu = (nu, A, t_T)$. $pi^n$ được gọi là tiềm năng của sự kiện $n in nu$.

- Nếu hình dung trục số nguyên là thời gian, thì các sự kiện có thể xảy ra ở các điểm số nguyên, và sự kiện n có thể xảy ra nhiều lần (do hệ tuần hoàn). Mỗi điểm như vậy được xem là một _tiềm năng sự kiện_.

Lịch trình (Schedule): Lịch trình là một ánh xạ từ sự kiện thành tiềm năng sự kiện (mốc thời gian).

$
Pi_nu &: nu -> ZZ \
     &: n |-> pi_n
$

Ràng buộc thời gian: Cho ràng buộc $a = ((i, j), [l_a, u_a]_(t_T))$. Hai tiềm năng sự kiện $pi_a "và" pi_b$ thỏa mãn ràng buộc thời gian $a$ khi và chỉ khi:

$ pi_a - pi_b in [l_a, u_a]_(t_T) $

Ràng buộc đối xứng: Cho ràng buộc $a = ((i, j), [l_a, u_a]_(t_T))$. Hai tiềm năng sự kiện $pi_a "và" pi_b$ thỏa mãn ràng buộc đối xứng $a$ khi và chỉ khi:

$ pi_a + pi_b in [l_a, u_a]_(t_T) $


Lịch trình hợp lệ (Valid schedule): Cho $Nu = (nu, A, t_T)$. Lịch trình $Pi_nu$ là hợp lệ khi và chỉ khi tất cả ràng buộc đều thỏa mãn

Lịch trình tương đương:  Cho $Nu = (nu, A, t_T)$. Lịch trình $Pi_nu$ và $Phi_nu$ là đương đương khi và chỉ khi 

$ Pi_nu equiv Phi_nu <=> forall n in nu, Pi_n mod t_T = Phi_n mod t_T $

Nếu hai lịch trình  $Pi_nu$ và $Phi_nu$ tương đương và $Pi_nu$ hợp lệ thì $Phi_nu$ cũng hợp lệ.

Nếu tồn lại một lịch trình hợp lệ thì tồn tại một lịch trình tương đương trong khoảng $[0, t_T - 1]$




=== PESP Solver

#lorem(30)

=== Solve PESP with SAT

#lorem(30)

=== Comparision

#lorem(30)