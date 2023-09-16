#include <stdlib.h>
#include <stdio.h>
void inputMatrix(int A[3][3])
{
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            scanf("%d", &A[i][j]);
        }
    }
}

void transposeMatrixA1(int A[3][3], int T[3][3], int size)
{
    for (int i = 0; i < size; i++)
    {
        for (int j = 0; j < size; j++)
        {
            T[j][i] = A[i][j];
        }
    }
}

void transposeMatrixA2(int *B, int *T, int size)
{
    int *ptrB;
    int *ptrT;
    int i;
    for (ptrB = B, ptrT = T, i = 1; ptrB < (B + (size * size)); ptrB++)
    {
        *ptrT = *ptrB;

        if (i < size)
        {
            ptrT += size;
            i++;
        }
        else
        {
            ptrT -= (size * (size - 1) - 1);
            i = 1;
        }
    }
}
void outputMatrix(int A[3][3])
{
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            printf("%d ", A[i][j]);
        }
        printf("\n");
    }
}

int main()
{
    int A[3][3];
    int transposeOfA1[3][3];
    int transposeOfA2[3][3];
    int *ptrA = &A[0][0];
    int *ptrTA2 = &transposeOfA2[0][0];

    inputMatrix(A);

    transposeMatrixA1(A, transposeOfA1, 3);
    transposeMatrixA2(ptrA, ptrTA2, 3);

    outputMatrix(transposeOfA1);
    outputMatrix(transposeOfA2);

    return 0;
}