import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

DateTime _selectedDay = DateTime.now();
DateTime _focusedDay = DateTime.now();
//int tabAccionesCal = 0;
List<bool> isSelected = [false,true ]; // 'Mes' está seleccionado inicialmente


class AgendaScreen extends StatefulWidget {
  
  @override
  State<AgendaScreen> createState() => AgendaScreenState();

}


class AgendaScreenState extends State<AgendaScreen>  {
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    CalendarFormat _calendarFormat = CalendarFormat.week;

    return Scaffold(
      appBar: AppBar(
        title: Text("Agenda"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Acción del botón de refrescar
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Container(
        width: size.width * 0.99,
        height: size.height,
        color: Colors.transparent,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Selector de Mes o Semana
              /*
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildToggleButton("Mes", false),
                        _buildToggleButton("Semana", true),
                      ],
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
              */
              
              SizedBox(height:  size.height * 0.02,),

              ToggleButtons(
            borderColor: Colors.purple,
            fillColor: Colors.purple,
            borderWidth: 2,
            selectedBorderColor: Colors.purple,
            selectedColor: Colors.white,
            borderRadius: BorderRadius.circular(20),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'Mes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected[0] ? Colors.white : Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'Semana',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected[1] ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < isSelected.length; i++) {
                  isSelected[i] = i == index;
                }
              });
            },
            isSelected: isSelected,
          ),
              
              if(isSelected[1])
              Container(
                width: size.width *0.95,
                height: size.height * 0.2,
                color: Colors.transparent,
                child: TableCalendar(     
                  calendarFormat: _calendarFormat,
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.now(),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return _focusedDay == day;
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay; // update `_focusedDay` here as well
                    });
                  }
                )
              ),
              
              if(isSelected[0])
              Container(
                width: size.width *0.95,
                height: size.height * 0.39,
                color: Colors.transparent,
                child: TableCalendar(     
                  //calendarFormat: _calendarFormat,
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.now(),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return _focusedDay == day;
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay; // update `_focusedDay` here as well
                    });
                  }
                )
              ),
              
              SizedBox(height: size.height * 0.008),
              // Barra de búsqueda
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Buscar agendas por código, nombre, RUC...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.007),
              // Lista de agendas
              Container(
                width: size.width *0.95,
                height: isSelected[1] ? size.height * 0.55 : size.height * 0.4,
                color: Colors.transparent,
                child: ListView.builder(
                  itemCount: 5, // Número de elementos en la lista
                  itemBuilder: (context, index) {
                    return _buildAgendaItem();
                  },
                ),
              ),
          
            ],
          ),
        ),
      ),
    );
  }

  // Widget para los botones de Mes/Semana
  Widget _buildToggleButton(String text, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          /*
          primary: isSelected ? Colors.blue : Colors.grey[200],
          onPrimary: isSelected ? Colors.white : Colors.black,
          */
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  // Widget para cada elemento de la agenda
  Widget _buildAgendaItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person),
          ),
          title: Text('Randy Rudolph'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Text('RUC/C: 095011183001', style: TextStyle(fontSize: 12)),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'RUC/C:',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    TextSpan(
                      text: '095011183001',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              //Text('COD: 59345', style: TextStyle(fontSize: 12)),

              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'COD:',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    TextSpan(
                      text: '59345',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),


              Text('Tipo de Agenda: Llamada', style: TextStyle(fontSize: 12)),
              Text('Activo', style: TextStyle(fontSize: 12, color: Colors.green)),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('10:20 AM', style: TextStyle(fontWeight: FontWeight.bold)),
              Icon(Icons.phone, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
