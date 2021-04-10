import requests


def covid():

    url = 'https://coronavirus-tracker-api.herokuapp.com/v2'
    args = '/locations/233?timelines=1'

    response = requests.get(url+args).json()
    # Casos confirmados
    return increase(response, 'confirmed', 1)


def increase(response: dict, mode: str, days: int):
    key_list = list(response['location']['timelines'][mode]['timeline'].keys())
    current_time = key_list[-1]
    previous_time = key_list[-1-days]
    previous_previous_time = key_list[-1-days*2]
    current_value = response['location']['timelines'][mode]['timeline'][current_time]
    previous_value = response['location']['timelines'][mode]['timeline'][previous_time]
    previous_previous_value = response['location']['timelines'][mode]['timeline'][previous_previous_time]
    return [current_value - previous_value, (current_value - previous_value) - (previous_value - previous_previous_value)]


if __name__ == '__main__':
    p = covid()
    print(' ', p[0], '  (▲ ', p[1], ')', sep='')
