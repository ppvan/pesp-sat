= Contents

== Trang bìa & Tóm tắt & Lời cảm ơn và tuyên thệ

- Trang bìa theo chuẩn của VNU, lời cảm ơn và tuyên thệ... thường có sẵn trong các template khóa luận của các cựu sinh viên

- Riêng phần abstact trình bày sơ bộ vấn đề và nội dung của thesis, sẽ update nhiều lần khi xong demo

== Introduction

- Giới thiệu bài toán lập lịch tuần hoàn, ứng dụng trong lập lịch trình tàu chạy.

- Những nghiên cứu trước về cách mô hình hóa bài toán

- Thesis này constribute cái gì (hiện tại thì không gì cả :( )

== Background and Related Work

=== Logic Mệnh đề

+ Định nghĩa logic mệnh đề

+ Sơ lược về đại số bool và các quy luật logic

+ Dạng chuẩn tắc hội

=== SAT Problem

+ Miêu tả về bài toán SAT và các khái niệm liên quan như NP-complete

+ SAT solver là gì, tiến độ nghiên cứu như thế nào

+ Hướng tiếp cận vấn đề sử dụng SAT-encoding (encode-> solve->decode).

=== Periodic event schedule network (PESP)

+ Giới thiệu bài toán PESP, lần đầu tạo ra bởi ai, bài báo nào, giải quyết vấn đề gì
  + Khái niệm interval
  + constraint
  + symetry
  + periodic constraint network

+ Các hướng tiếp cận để giải bài toán PESP (Integer programing, constaint propagation...)

+ Vấn đề về hiệu năng của các phương pháp trên
Nêu ra một số vấn đề khác có thể giải nhanh hơn dùng sat solver (nếu có)

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

=== Ước lượng và so sánh các phương pháp trên về lý thuyết (Big O notation, số mệnh đề, số biến ...)


=== Mô hình bài toán lập lịch đường tàu sử dụng mô hình PESP 

- Giới thiệu các yêu cầu nghiệp vụ của lập lịch tàu
- Mô hình hóa các ràng buộc thành ràng buộc của bài toán PESP

== Thực thi và kết quả đạt được

=== Dataset

https://timpasslib.aalto.fi/pesplib.html

=== Kết quả

+ Bảng so sánh thời gian + tài nguyên (số mệnh đề, số biến...) giải các bài toán PESP trong dataset với từng encoding và 1 phương pháp khác


== Kết luận và dự định (future work)

- Kết luận về cách tiếp cận SAT với vấn đề lập lịch trình tàu

- Hướng phát triển tiếp theo (lập lịch tối ưu, tìm ra ràng buộc quan trọng...)




