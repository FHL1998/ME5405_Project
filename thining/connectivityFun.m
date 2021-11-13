function [Cn endPoint] = connectivityFun(inwindow)
i=2;j=2;
N0 = inwindow(i,j);
N1 = inwindow(i,j+1);
N2 = inwindow(i-1,j+1);
N3 = inwindow(i-1,j);
N4 = inwindow(i-1,j-1);
N5 = inwindow(i,j-1);
N6 = inwindow(i+1,j-1);
N7 = inwindow(i+1,j);
N8 = inwindow(i+1,j+1);

% arr = [(N1-(N3*N1*N2)) (N3-(N5*N3*N4)) (N5-(N7*N5*N6)) (N7-(N1*N7*N8))];
val = [N1 N2 N3 N4 N5 N6 N7 N8];
arr = [N1<N2 N2<N3 N3<N4 N4<N5 N5<N6 N6<N7 N7<N8 N8<N1];
   

Cn = sum(arr);

endPoint = abs(N0 - sum(val));