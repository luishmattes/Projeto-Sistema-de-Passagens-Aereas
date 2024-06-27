import time # Varias funcoes relacionadas a tempo (Pause, delays, obtencao de tempo atual)
import pyautogui # automação de interface gráfica do usuário 
import mysql.connector # Conexao com DB MySQL
from mysql.connector import Error # Importa a classe Error do módulo mysql.connector para lidar com exceções específicas do MySQL.
from tabulate import tabulate # usada para formatar dados tabulares de uma maneira bonita e legível.
from datetime import datetime, timedelta # Manipulação de datas


def connect():
    try:
        return mysql.connector.connect(
            host='localhost',
            user='root',
            password='admin',
            database='sistema_voo'
        )
    except Error as e:
        print("Erro ao conectar ao MySQL:", e)
        return None


# Funções para CRUD Passageiros

def add_passageiro(cpf, rg, nome, data_nascimento, email, cidade_residencia, unidade_federativa):
    conn = connect()
    if conn is None:
        return

    cursor = conn.cursor()
    try:
        cursor.execute('''
            INSERT INTO Passageiro (Cpf, rg, nome, data_nascimento, email, cidade_residencia, unidade_federativa) 
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        ''', (cpf, rg, nome, data_nascimento, email, cidade_residencia, unidade_federativa))
        conn.commit()
        print("Passageiro adicionado com sucesso!")
    except mysql.connector.IntegrityError as e:
        if e.errno == 1062:   # Erro do MYSQL
            print("Erro: Já existe um passageiro com este CPF registrado.")
        else:
            print("Erro ao adicionar passageiro:", e)
    finally:
        conn.close()

def get_passageiro(cpf):
    conn = connect()
    if conn is None:
        return None, None

    cursor = conn.cursor()
    cursor.execute('SELECT * FROM Passageiro WHERE Cpf = %s', (cpf,))
    passageiro = cursor.fetchone()

    if passageiro:
        headers = ["CPF", "RG", "Nome", "Data de Nascimento", "Email", "Cidade de Residência", "Unidade Federativa"]
        print(tabulate([passageiro], headers, tablefmt="grid"))

    return conn, passageiro

def update_passageiro():
    cpf = input("Informe o CPF do passageiro que deseja atualizar: ")
    conn, passageiro = get_passageiro(cpf)
    
    if passageiro is None:
        print("Erro: Passageiro não encontrado.")
        return

    rg = input("Novo RG: ")
    nome = input("Novo Nome: ")
    data_nascimento = input("Nova Data de Nascimento (YYYY-MM-DD): ")
    email = input("Novo Email: ")
    cidade_residencia = input("Nova Cidade de Residência: ")
    unidade_federativa = input("Nova Unidade Federativa: ")

    cursor = conn.cursor()
    try:
        cursor.execute('''
            UPDATE Passageiro 
            SET rg = %s, nome = %s, data_nascimento = %s, email = %s, cidade_residencia = %s, unidade_federativa = %s
            WHERE Cpf = %s
        ''', (rg, nome, data_nascimento, email, cidade_residencia, unidade_federativa, cpf))
        conn.commit()
        print("Passageiro atualizado com sucesso!")
    except mysql.connector.Error as e:
        print("Erro ao atualizar passageiro:", e)
    finally:
        conn.close()



def delete_passageiro(cpf):
    if not get_passageiro(cpf):
        print("Erro: Passageiro não encontrado.")
        return

    conn = connect()
    if conn is None:
        return

    cursor = conn.cursor()
    cursor.execute('DELETE FROM Passageiro WHERE Cpf = %s', (cpf,))
    conn.commit()
    print("Passageiro deletado com sucesso!")
    conn.close()




# Funções para CRUD Reservas
def get_next_codigo_reserva():
    conn = connect()
    if conn is None:
        return None

    cursor = conn.cursor()
    cursor.execute('SELECT MAX(codigo_reserva) FROM Reserva')
    max_codigo_reserva = cursor.fetchone()[0]
    conn.close()

    if max_codigo_reserva is None:
        return 1
    else:
        return max_codigo_reserva + 1

def add_reserva():
    conn = connect()
    if conn is None:
        return

    try:
        cpf = input("CPF do passageiro: ")
        data_reserva = input("Data da reserva (YYYY-MM-DD): ")

        codigo_reserva = get_next_codigo_reserva()
        data_expiracao = (datetime.strptime(data_reserva, "%Y-%m-%d") + timedelta(days=30)).strftime("%Y-%m-%d")
        status_reserva = "Pendente"

        cursor = conn.cursor()
        cursor.execute('''
            INSERT INTO Reserva (codigo_reserva, cpf, data_reserva, status_reserva, data_expiracao) 
            VALUES (%s, %s, %s, %s, %s)
        ''', (codigo_reserva, cpf, data_reserva, status_reserva, data_expiracao))
        conn.commit()
        print(f"Reserva adicionada {codigo_reserva} com sucesso!")
        
    except mysql.connector.Error as e:
        conn.rollback()  # Desfaz qualquer mudança pendente no banco de dados
        print("Erro ao adicionar reserva:", e)
    finally:
        if conn.is_connected():
            cursor.close()
            conn.close()


def get_reserva(codigo_reserva):
    conn = connect()
    if conn is None:
        return None, None

    cursor = conn.cursor()
    cursor.execute('SELECT * FROM Reserva WHERE codigo_reserva = %s', (codigo_reserva,))
    reserva = cursor.fetchone()

    if reserva:
        headers = ["Código Reserva", "CPF", "Data de Reserva", "Status Reserva", "Data Expiração"]
        print(tabulate([reserva], headers, tablefmt="grid"))

    return conn, reserva

def update_reserva():
    codigo_reserva = input("Informe o código da reserva que deseja atualizar: ")
    conn, reserva = get_reserva(codigo_reserva)
    
    if reserva is None:
        print("Erro: Reserva não encontrada.")
        return

    cpf = input("Novo CPF: ")
    data_reserva = input("Nova Data da Reserva (YYYY-MM-DD): ")
    status_reserva = input("Novo Status da Reserva: ")

    # Calcula nova data de expiração
    data_expiracao = (datetime.strptime(data_reserva, "%Y-%m-%d") + timedelta(days=30)).strftime("%Y-%m-%d")

    cursor = conn.cursor()
    try:
        cursor.execute('''
            UPDATE Reserva 
            SET cpf = %s, data_reserva = %s, status_reserva = %s, data_expiracao = %s
            WHERE codigo_reserva = %s
        ''', (cpf, data_reserva, status_reserva, data_expiracao, codigo_reserva))
        conn.commit()
        print("Reserva atualizada com sucesso!")
    except mysql.connector.Error as e:
        print("Erro ao atualizar reserva:", e)
    finally:
        conn.close()


def delete_reserva(codigo_reserva):
    if not get_reserva(codigo_reserva):
        print("Erro: Reserva não encontrada.")
        return

    conn = connect()
    if conn is None:
        return

    cursor = conn.cursor()
    cursor.execute('DELETE FROM Reserva WHERE codigo_reserva = %s', (codigo_reserva,))
    conn.commit()
    print("Reserva deletada com sucesso!")
    conn.close()


# Menu principal do sistema

def menu_principal():
    while True:
        print("=== Menu Principal ===")
        print("1. Passageiros")
        print("2. Reservas")
        print("3. Vendas")
        print("4. Aeronaves")
        print("5. Trechos")
        print("6. Voos")
        print("7. Operadoras de cartão")
        print("0. Sair")
        escolha = input("Escolha uma opção: \n")

        if escolha == '1':
            menu_passageiros()
        elif escolha == '2':
            menu_reservas()
        elif escolha in {'3', '4', '5', '6', '7'}:
            print(f"Menu de {escolha} (em desenvolvimento)...")
        elif escolha == '0':
            print("Saindo...")
            break
        else:
            print("Opção inválida. Tente novamente.\n")

def menu_passageiros():
    while True:
        print("\n\n==== Passageiros ====")
        print("1. Adicionar Passageiro")
        print("2. Visualizar Passageiro")
        print("3. Atualizar Passageiro")
        print("4. Deletar Passageiro")
        print("5. Voltar ao Menu Principal")
        choice = input("Escolha uma opção: \n")

        if choice == '1':
            # Adicionar passageiro
            cpf = input("CPF: ")
            rg = input("RG: ")
            nome = input("Nome: ")
            data_nascimento = input("Data de Nascimento (YYYY-MM-DD): ")
            email = input("Email: ")
            cidade_residencia = input("Cidade de Residência: ")
            unidade_federativa = input("Unidade Federativa: ")

            add_passageiro(cpf, rg, nome, data_nascimento, email, cidade_residencia, unidade_federativa)
        elif choice == '2':
            # Visualizar passageiro
            cpf = input("CPF: ")
            get_passageiro(cpf)
        elif choice == '3':
            # Atualizar passageiro
            update_passageiro()
        elif choice == '4':
            # Deletar passageiro
            cpf = input("CPF: ")
            delete_passageiro(cpf)
        elif choice == '5':
            break
        else:
            print("Opção inválida. Tente novamente.")


def menu_reservas():
    while True:
        print("\n\n==== Reservas ====")
        print("1. Adicionar Reserva")
        print("2. Visualizar Reserva")
        print("3. Atualizar Reserva")
        print("4. Deletar Reserva")
        print("5. Voltar ao Menu Principal")
        choice = input("Escolha uma opção: \n")

        if choice == '1':
            # Adicionar reserva
            add_reserva()
        elif choice == '2':
            # Visualizar reserva
            codigo_reserva = input("Código da Reserva: ")
            get_reserva(codigo_reserva)
        elif choice == '3':
            # Atualizar reserva
            update_reserva()
        elif choice == '4':
            # Deletar reserva
            codigo_reserva = input("Código da Reserva: ")
            delete_reserva(codigo_reserva)
        elif choice == '5':
            break
        else:
            print("Opção inválida. Tente novamente.")


if __name__ == "__main__":
    menu_principal()