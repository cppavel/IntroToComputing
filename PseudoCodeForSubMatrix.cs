using System;


namespace SubArrayPseudoCode
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
            int[,] B = new int[,] { { 29, 17, 22 }, { 37, 35, 38 } };

            printMatrix(A);
            printMatrix(B);

            int w_sub = B.GetLength(0); //number of elements in a column
            int h_sub = B.GetLength(1); //number of elements in a row

            int counter_w = 0;
            int counter_h = 0;
            bool line_done = false;
            bool sub_matrix = false;

            for (int i = 0; i < A.GetLength(0); i++)
            {
                for (int j = 0; j < A.GetLength(1); j++)
                {
                    if (A[i, j] == B[counter_w, counter_h])
                    {
                        counter_h++;
                    }
                    else
                    {
                        counter_h = 0;
                    }

                    if (counter_h == h_sub)
                    {
                        counter_h = 0;
                        line_done = true;
                        break;
                    }
                }
                if (line_done)
                {
                    counter_w++;
                    line_done = false;
                }
                else
                {
                    counter_w = 0;
                }
                if (counter_w == w_sub)
                {
                    sub_matrix = true;
                    break;
                }
            }

            if (sub_matrix)
            {
                Console.WriteLine("B is a submatrix of A");
            }
            else
            {
                Console.WriteLine("B is NOT a submatrix of A");
            }

            Console.ReadKey();
        }
    }
}
