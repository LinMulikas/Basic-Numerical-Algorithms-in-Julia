import numpy as np
import matplotlib.pyplot as plt
from scipy.linalg import lu

def Jacobi(A:np.ndarray, x0:np.ndarray, b:np.ndarray, MAX_STEP = 20):
    cnt = 0
    (n, m) = A.shape
    x_old = x0
    x_new = np.zeros((x0.shape[0], ))
    D = np.diag(A.diagonal())
    
    while(cnt < MAX_STEP):
        x_new = np.dot(np.linalg.inv(D), b + np.dot(D - A, x_old))
            
        cnt += 1
        x_old = x_new.copy()
     
     
    return x_new

def SOR_Jacobi(A:np.ndarray, x0:np.ndarray, b:np.ndarray, w = 1, MAX_STEP = 20):
    cnt = 0
    (n, m) = A.shape
    x_old = x0
    x_new = np.zeros((x0.shape[0], ))
    D = np.diag(A.diagonal())
    
    while(cnt < MAX_STEP):
        x_new = w * np.dot(np.linalg.inv(D), b + np.dot(D - A, x_old))
            
        cnt += 1
        x_old = x_new.copy()
     
     
    return x_new


def Gauss_Seidel(A:np.ndarray, x0:np.ndarray, b:np.ndarray, MAX_STEP = 20):
    cnt = 0
    (n, m) = A.shape
    D = np.diag(A.diagonal())
    
    while(cnt < MAX_STEP):
        for i in range(n):
            x0[i] = (b[i] + np.dot(((D - A)[i, :]), x0))/D[i, i]
            
        cnt += 1
    
     
    return x0


N = 49
h = 1/(N + 1)
xj = np.linspace(1, N + 1)*h
A = np.zeros((N + 1, N + 1), dtype=float)

f = lambda x : 12*x**2 - 12*x + 2 - 100*x**2*(1 - x)**2
u = lambda x : x**2*(1 - x)**2

F = f(xj)
U_true = u(xj)  

for i in range(50):
    for j in range(50):
        if(abs(i - j) == 1):
            A[i, j] = 1/h**2
        if(abs(i - j) == 0):
            A[i, j] = -(2/h**2 + 100)
        

P, L, U = lu(A)
y = np.linalg.inv(L) @ F
U_GE = np.linalg.inv(U) @ y        
    
fig1 = plt.figure(1)
plt.subplot(121)
plt.title("LU method")
plt.plot(xj, U_true)
plt.plot(xj, U_GE)
plt.legend(["U_true", "U_GE"])

plt.subplot(122)
plt.title("Error")
plt.scatter(xj, U_GE - U_true)
plt.show()

x0 = np.zeros((N + 1, ))


U_J = Jacobi(A, x0, F)
fig2 = plt.figure(2)
plt.subplot(121)
plt.title("Jacobi")
plt.plot(xj, U_true)
plt.plot(xj, U_J)
plt.legend(["U_true", "U_J"])
plt.subplot(122)
plt.title("Error")
plt.scatter(xj, U_J - U_true)
plt.show()

U_GS = Gauss_Seidel(A, x0 , F)
fig3 = plt.figure(3)
plt.subplot(121)
plt.title("Gauss-Seidel")
plt.plot(xj, U_true)
plt.plot(xj, U_GS)
plt.legend(["U_true", "U_GS"])
plt.subplot(122)
plt.title("Error")
plt.scatter(xj, U_GS - U_true)
plt.show()

U_SOR = SOR_Jacobi(A, x0 , F, w = 2/(1 + np.sin(np.pi/49)))
fig4 = plt.figure(4)
plt.subplot(121)
plt.title("SOR")
plt.plot(xj, U_true)
plt.plot(xj, U_SOR)
plt.legend(["U_true", "U_SOR"])
plt.subplot(122)
plt.title("Error")
plt.scatter(xj, U_SOR - U_true)
plt.show()