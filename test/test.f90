program main

  use number2string
  implicit none


  print'(a)', real2str(-acos(-1.0d0),1,4)
  print'(a)', real2str(-10*acos(-1.0d0),2,8) 

end program main
