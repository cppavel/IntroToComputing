using System;


namespace AssemblySubMatrix
{
    class Program
    {

        static void printMatrix(int[,] matrix)
        {
            for (int i = 0; i < matrix.GetLength(0); i++)
            {
                for (int j = 0; j < matrix.GetLength(1); j++)
                {
                    Console.Write(matrix[i, j] + " ");
                }
                Console.WriteLine();
            }
            Console.WriteLine();
        }
        static void Main(string[] args)
        {
            int[,] A = new int[,] { { 48,37,15,44,3,17,26},{ 2, 9, 12, 18, 14, 33, 16 },{ 13, 20, 1, 22, 7, 48, 21 },{ 27, 19, 44, 49, 44, 18, 10 },
            {29,17,22,4,46,43,41 },{37,35,38,34,16,25,0 },{17,0,48,15,27,35,11 } };
            int[,] B = new int[,] { { 49, 44, 18 }, { 4, 46, 43, }, { 34, 16, 25 } };

            printMatrix(A);
            printMatrix(B);

            int w_sub = B.GetLength(0); //number of elements in a column
            int h_sub = B.GetLength(1); //number of elements in a row

            for(int i = 0; i<A.GetLength(0)-w_sub;i++)
            {
                for (int j = 0; j < A.GetLength(1)-h_sub; j++)
                {
                    int w_cur = 0;
                    int h_cur = 0;
                    
                    while(w_cur<w_sub&&B[w_cur,h_cur]==A[i + w_cur,j + h_cur])
                    {
                        h_cur++;
                        if (h_cur == h_sub)
                        {
                            h_cur = 0;
                            w_cur++;
                        }
                    }
                    if(w_cur==w_sub)
                    {
                        Console.WriteLine("SubMatrix");
                    }
                    
                }
            }
            Console.ReadKey();
        }
    }
}