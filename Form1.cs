using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace Agentie_Turism
{
    public partial class Form1 : Form
    {
        string connectionString = "Server=DESKTOP-0TJ6SRG\\SQLEXPRESS;Database=AgentieDeTurism;Integrated Security=true;";
        DataSet ds = new DataSet();
        SqlDataAdapter da = new SqlDataAdapter();
        SqlDataAdapter adapterParent = new SqlDataAdapter();
        SqlDataAdapter adapterChild = new SqlDataAdapter();
        BindingSource bsParent = new BindingSource();
        BindingSource bsChild = new BindingSource();
        private DateTimePicker timePicker;

        public Form1()
        {
            //new Form2().Show();
            InitializeComponent();
            fillBox();
        }


        private void Form1_Load(object sender, EventArgs e)
        {

            this.Text = "Agentie de turism";
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();


                    /*                    dateLeft.CustomFormat = "dddd,MMMM dd,yyyy hh:mm";
                                        dateLeft.Format = DateTimePickerFormat.Custom;*/

                    /*                    timePicker = new DateTimePicker();
                                        timePicker.Format = DateTimePickerFormat.Time;
                                        timePicker.ShowUpDown = true;
                                        timePicker.Location = new Point(10, 10);
                                        timePicker.Width = 100;
                                        Controls.Add(timePicker);*/

                    adapterParent.SelectCommand = new SqlCommand("SELECT * FROM FirmaTransport;", connection);
                    adapterChild.SelectCommand = new SqlCommand("SELECT * FROM Traseu;", connection);
                    adapterParent.Fill(ds, "FirmaTransport");
                    adapterChild.Fill(ds, "Traseu");
                    bsParent.DataSource = ds.Tables["FirmaTransport"];
                    dataGridView1.DataSource = bsParent;
                    DataColumn pk = ds.Tables["FirmaTransport"].Columns["cod_firma"];
                    DataColumn fk = ds.Tables["Traseu"].Columns["FIRMA_TRANSPORT"];
                    DataRelation relation = new DataRelation("fk_firma_transport", pk, fk);
                    ds.Relations.Add(relation);
                    bsChild.DataSource = bsParent;
                    bsChild.DataMember = "fk_firma_transport";
                    dataGridView2.DataSource = bsChild;
                    adapterChild.InsertCommand = new SqlCommand("INSERT INTO Traseu (cod_t,nume,nr_angajati,website) VALUES" +
                "(@cod_t,@nume,@nr_angajati,@website)", connection);
                    stopsBox.DataBindings.Add("Text", bsChild, "OPRIRI");
                    comboBoxType.Items.Add("City break");
                    comboBoxType.Items.Add("Excursie montana");
                    comboBoxType.DataBindings.Add("Text", bsChild, "TIP");
                    dateLeft.DataBindings.Add("Text", bsChild, "data_plecarii");
                    dateBack.DataBindings.Add("Text", bsChild, "data_intoarcerii");
                    comboBoxId.DataBindings.Add("Text", bsParent, "cod_firma");
                    IDtraseuBox.DataBindings.Add("Text", bsChild, "cod_t");
       
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        public void fillBox()
        {
            SqlConnection connection = new SqlConnection(connectionString);
            SqlCommand cmd = new SqlCommand("SELECT * FROM FirmaTransport",connection);
            SqlDataReader reader;
            connection.Open();
            try
            {
                reader = cmd.ExecuteReader();
                while(reader.Read())
                {
                    int id = reader.GetInt32(0);
                    comboBoxId.Items.Add(id);
                }
            }
            catch(Exception exc)
            {
                MessageBox.Show(exc.Message);
            }
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox3_TextChanged(object sender, EventArgs e)
        {

        }


        private void UpdateButton_Click(object sender, EventArgs e)
        {

        }

        private void insertButton_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    int x;

                    adapterChild.InsertCommand = new SqlCommand("INSERT INTO Traseu VALUES(@opriri,@tip," +
                        "@data_plecare,@data_intoarcere,@firma)", connection);
                    adapterChild.InsertCommand.Parameters.Add("@firma", SqlDbType.Int).Value = comboBoxId.Text;
                    if(stopsBox.Text == "")
                        throw new Exception("Campurile nu pot fi goale!");
                    adapterChild.InsertCommand.Parameters.Add("@opriri", SqlDbType.VarChar).Value = stopsBox.Text;
                    adapterChild.InsertCommand.Parameters.Add("@tip", SqlDbType.VarChar).Value = comboBoxType.Text;
                    adapterChild.InsertCommand.Parameters.Add("@data_plecare", SqlDbType.DateTime).Value = dateLeft.Text;
                    adapterChild.InsertCommand.Parameters.Add("@data_intoarcere", SqlDbType.DateTime).Value = dateBack.Text;

                    connection.Open();
                    //adapterChild.InsertCommand.ExecuteNonQuery();
                    //connection.Close();

                    x = adapterChild.InsertCommand.ExecuteNonQuery();
                    connection.Close();
                    if (x >= 1)
                    {
                        MessageBox.Show("Inserare realizata cu succes.");
                    }
                    refreshDatabase();
                }
            }
            catch(Exception exc)
            {
                MessageBox.Show(exc.Message);
            }
        }
        private void refreshDatabase()
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                adapterParent.SelectCommand = new SqlCommand("SELECT * FROM FirmaTransport;", connection);
                adapterChild.SelectCommand = new SqlCommand("SELECT * FROM Traseu;", connection);
                ds.Clear();
                adapterParent.Fill(ds, "FirmaTransport");
                adapterChild.Fill(ds, "Traseu");
                bsParent.DataSource = ds.Tables["FirmaTransport"];
                dataGridView1.DataSource = bsParent;
                bsChild.DataSource = bsParent;
                dataGridView2.DataSource = bsChild;
                connection.Close();
            }
        }

        private void deleteButton_Click_1(object sender, EventArgs e)
        {
            DialogResult dr;
            dr = MessageBox.Show("Sunteti siguri?", "Confirmare stergere", MessageBoxButtons.YesNo);
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                if (dr == DialogResult.Yes)
                {
                    adapterChild.DeleteCommand = new SqlCommand("DELETE FROM Traseu WHERE cod_t=@id", connection);
                    adapterChild.DeleteCommand.Parameters.Add("@id", SqlDbType.Int).Value = IDtraseuBox.Text; //ds.Tables[0].Rows[bsChild.position][0]
                    connection.Open();
                    int x = adapterChild.DeleteCommand.ExecuteNonQuery();
                    connection.Close();
                    if (x >= 1)
                    {
                        MessageBox.Show("Stergere realizata cu succes.");
                    }
                    refreshDatabase();
                }
            }
        }

        private void updateButton_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    int x;

                    adapterChild.UpdateCommand = new SqlCommand("UPDATE Traseu SET OPRIRI=@stops,TIP=@type,data_plecarii=@left,data_intoarcerii=@back,FIRMA_TRANSPORT=@FT WHERE cod_t=@id");
                    adapterChild.UpdateCommand.Connection = connection;
                    if (stopsBox.Text == "")
                        throw new Exception("Campurile nu pot fi goale!");
                    adapterChild.UpdateCommand.Parameters.Add("@stops", SqlDbType.VarChar).Value = stopsBox.Text;
                    adapterChild.UpdateCommand.Parameters.Add("@type", SqlDbType.VarChar).Value = comboBoxType.Text;
                    adapterChild.UpdateCommand.Parameters.Add("@left", SqlDbType.DateTime).Value = dateLeft.Text;
                    adapterChild.UpdateCommand.Parameters.Add("@back", SqlDbType.DateTime).Value = dateBack.Text;
                    adapterChild.UpdateCommand.Parameters.Add("@FT", SqlDbType.Int).Value = comboBoxId.Text;
                    adapterChild.UpdateCommand.Parameters.Add("@id", SqlDbType.Int).Value = IDtraseuBox.Text;


                    x = adapterChild.UpdateCommand.ExecuteNonQuery();
                    connection.Close();
                    if (x >= 1)
                    {
                        MessageBox.Show("Actualizare realizata cu succes.");
                    }
                    refreshDatabase();
                }
            }
            catch(Exception exc)
            {
                MessageBox.Show(exc.Message);
            }

        }

        private void exitbutton_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }
    }
}
