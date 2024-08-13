= Contents

== Introduction

- Giới thiệu bài toán lập lịch tuần hoàn, ứng dụng trong lập lịch trình tàu chạy. Những nghiên cứu trước về cách mô hình hóa bài toán


== Background and Related Work

=== Logic Mệnh đề

- Định nghĩa logic mệnh đề, biểu thức logic, các kí hiệu (notation) sẽ dùng trong các chương sau

=== SAT Problem

- Miêu tả về bài toán SAT và các khái niệm liên quan như NP-complete
- Miêu tả thành tựu của các SAT solver hiện tại và ứng dụng trong giải quyết vấn đề thực tế

- Hướng tiếp cận vấn đề sử dụng SAT-encoding (encode-> solve->decode).

=== Periodic event schedule network (PESP)

- Giới thiệu bài toán PESP
- Các hướng tiếp cận để giải bài toán PESP (Integer programing, constaint based...)
- Vấn đề về hiệu năng của các phương pháp trên, nếu ra một số vấn đề khác có thể giải nhanh hơn dùng sat solver (nếu có)

== Encoding bài toán PESP về bài toán SAT

=== Direct encoding
- Cách encode variable và constraint dùng direct encodeing
- Phương pháp maping từ PESP vars => SAT vars, cách để cài đặt và infer từ kết quả giải của solver

=== Support encoding (nếu đủ effort)

- Support encoding thay vì cố gắng loại bỏ conflict thì liên kết các nghiệm lại với nhau. Ví dụ $x_1, x_2 = (1,2)$ là một nghiệm ta có mệnh đề $p_(x_11) => p_(x_22)$

- Tùy vào không gian nghiệm và không gian conflict nhiều hơn mà encoding này có thể hiệu quả hơn

=== Order encoding
- Giới thiệu order encoding và cách encode variable trong miền order
- Encode ràng buộc trong miền order

== Thực thi và kết quả đạt được

=== Dataset

https://timpasslib.aalto.fi/pesplib.html

=== Kết quả

== Kết luận và dự định

- Kết luận về cách tiếp cận SAT với vấn đề lập lịch trình tàu

- Hướng phát triển tiếp theo (lập lịch tối ưu, tìm ra ràng buộc quan trọng...)




