import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:snapchat_proj/data/models/country_code.dart';
import 'package:snapchat_proj/data/repository/country_code_repository.dart';
import 'package:snapchat_proj/global/theme/styles.dart';
import 'package:snapchat_proj/global/widgets/card.dart';
import 'package:snapchat_proj/localization/localization.dart';

import 'country_code_bloc/bloc/country_code_bloc.dart';

class CountryCode extends StatefulWidget {
  const CountryCode({required this.countryValueNotifier});
  final ValueNotifier<CountryCodeModel> countryValueNotifier;
  @override
  _CountryCodeState createState() => _CountryCodeState();
}

class _CountryCodeState extends State<CountryCode> {
  final CountryCodeBloc _countryCodeBloc =
      CountryCodeBloc(countryCodeRepository: CountryCodeRepository());

  final TextEditingController _searchFieldController = TextEditingController();
  List<CountryCodeModel> items = [];

  late CountryCodeModel selectedCountryCode;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("init");
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Styles.backIconColor,
          ),
          backgroundColor: Styles.whiteThemeColor,
          elevation: 0,
        ),
        body: BlocProvider<CountryCodeBloc>(
            create: (context) {
              _countryCodeBloc.add(LoadloadCountryCodeList());

              return _countryCodeBloc;
            },
            child: BlocListener<CountryCodeBloc, CountryCodeState>(
              listener: (context, state) {
                print(state);
                if (state is CountryCodeLoadedState) {
                  setState(() {
                    items = state.loadedCountryCode;
                  });
                }
              },
              child: _render(),
            )));
  }

  Widget _render() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _searchBar(),
          BlocBuilder<CountryCodeBloc, CountryCodeState>(
              builder: (context, state) {
            return Expanded(child: _listView(items));
          }),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: _searchFieldController,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            filled: true,
            hintStyle: Styles.hintTextStyle,
            hintText:
                DemoLocalizations.of(context).getTranslatedValue('search'),
            fillColor: Styles.whiteThemeColor),
        onChanged: (text) {
          _countryCodeBloc
              .add(SearchCountry(countryName: _searchFieldController.text));
        },
      ),
    );
  }

  Widget _listView(List<CountryCodeModel> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (ctx, index) {
        return GestureDetector(
            onTap: () {
              widget.countryValueNotifier.value = items[index];
              Navigator.pop(context);
            },
            child: CountryCard(
              country: items[index],
            ));
      },
    );
  }

  @override
  void dispose() {
    _countryCodeBloc.close();
    super.dispose();
  }
}
