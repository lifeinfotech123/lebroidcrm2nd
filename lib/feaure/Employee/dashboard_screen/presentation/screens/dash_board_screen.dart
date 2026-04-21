import 'package:flutter/material.dart';

import '../widget/bar_graph_widget.dart';
import '../widget/graph_widget.dart';
import '../widget/order_list_widget.dart';
import '../widget/pie_graph_widget.dart';
import '../widget/show_data_container.dart';


class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Dashboard',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 125,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _card(
                      const ShowDataContainer(
                        label: 'Total Employee',
                        total: '21',
                        progressTitle: '3% higher',
                        progressValue: 0.7,
                        backgroundColor: Colors.pinkAccent,
                        trendIcon: Icons.trending_up,
                      ),
                    ),
                    _card(
                      const ShowDataContainer(
                        label: 'Present',
                        total: '18',
                        progressTitle: '8% higher',
                        progressValue: 0.6,
                        backgroundColor: Colors.deepPurpleAccent,
                        trendIcon: Icons.bar_chart,
                      ),
                    ),
                    _card(
                      const ShowDataContainer(
                        label: 'Absent',
                        total: '3',
                        progressTitle: '6% lower',
                        progressValue: 0.3,
                        backgroundColor: Colors.blueAccent,
                        trendIcon: Icons.trending_down,
                      ),
                    ),
                    _card(
                      const ShowDataContainer(
                        label: 'Avg Check-in',
                        total: '11:13',
                        progressTitle: '9% higher',
                        progressValue: 0.8,
                        backgroundColor: Colors.green,
                        trendIcon: Icons.show_chart,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 125,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _card(
                      const ShowDataContainer(
                        label: 'Total Projects',
                        total: '21',
                        progressTitle: '3% higher',
                        progressValue: 0.7,
                        backgroundColor: Colors.pinkAccent,
                        trendIcon: Icons.trending_up,
                      ),
                    ),
                    _card(
                      const ShowDataContainer(
                        label: 'Total Business',
                        total: '18',
                        progressTitle: '8% higher',
                        progressValue: 0.6,
                        backgroundColor: Colors.deepPurpleAccent,
                        trendIcon: Icons.bar_chart,
                      ),
                    ),
                    _card(
                      const ShowDataContainer(
                        label: 'Total Salary',
                        total: '3',
                        progressTitle: '6% lower',
                        progressValue: 0.3,
                        backgroundColor: Colors.blueAccent,
                        trendIcon: Icons.trending_down,
                      ),
                    ),
                    _card(
                      const ShowDataContainer(
                        label: 'Total Expenses',
                        total: '11:13',
                        progressTitle: '9% higher',
                        progressValue: 0.8,
                        backgroundColor: Colors.green,
                        trendIcon: Icons.show_chart,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 125,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _card(
                      const ShowDataContainer(
                        label: 'Total Office Expenses',
                        total: '21',
                        progressTitle: '3% higher',
                        progressValue: 0.7,
                        backgroundColor: Colors.pinkAccent,
                        trendIcon: Icons.trending_up,
                      ),
                    ),
                    _card(
                      const ShowDataContainer(
                        label: 'Total Home Expenses',
                        total: '18',
                        progressTitle: '8% higher',
                        progressValue: 0.6,
                        backgroundColor: Colors.deepPurpleAccent,
                        trendIcon: Icons.bar_chart,
                      ),
                    ),
                    _card(
                      const ShowDataContainer(
                        label: 'Total Profit',
                        total: '3',
                        progressTitle: '6% lower',
                        progressValue: 0.3,
                        backgroundColor: Colors.blueAccent,
                        trendIcon: Icons.trending_down,
                      ),
                    ),
                    _card(
                      const ShowDataContainer(
                        label: 'Loss',
                        total: '11:13',
                        progressTitle: '9% higher',
                        progressValue: 0.8,
                        backgroundColor: Colors.green,
                        trendIcon: Icons.show_chart,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              BarGraphWidget(),
              const SizedBox(height: 12),
              PieGraphWidget(),
              const SizedBox(height: 12),
              GraphWidget(),
              ListView(
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  const Text(
                    'Recent Orders',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  OrderListWidget(
                    name: 'John Doe',
                    id: '#ORD-1023',
                    date: '12 Sep 2024',
                    status: 'Completed',
                    monile: '+1 234 567 890',
                    email: 'john.doe@gmail.com',
                    payment: '\$250',
                    imageUrl: 'https://i.pravatar.cc/150?img=3',
                  ),

                  OrderListWidget(
                    name: 'Emma Watson',
                    id: '#ORD-1024',
                    date: '13 Sep 2024',
                    status: 'Pending',
                    monile: '+1 987 654 321',
                    email: 'emma.watson@gmail.com',
                    payment: '\$180',
                    imageUrl: 'https://i.pravatar.cc/150?img=5',
                  ),

                  OrderListWidget(
                    name: 'Michael Scott',
                    id: '#ORD-1025',
                    date: '14 Sep 2024',
                    status: 'Cancelled',
                    monile: '+1 456 789 123',
                    email: 'michael@dundermifflin.com',
                    payment: '\$90',
                    imageUrl: 'https://i.pravatar.cc/150?img=8',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(Widget child) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 10),
      child: child,
    );
  }
}
