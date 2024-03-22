function [S] = tan_sim(X,Y)

S=dot(X,Y)/(dot(X,X)+dot(Y,Y)-dot(X,Y));

end