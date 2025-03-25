shader_type canvas_item;

uniform float blink_speed : hint_range(0.1, 10.0) = 2.0; // Скорость мигания
uniform float blink_intensity : hint_range(0.0, 1.0) = 0.5; // Интенсивность мигания (насколько ярче становится)
uniform float blink_duration : hint_range(0.1, 10.0) = 0.5; // Длительность мигания в секундах
uniform float no_blink_duration : hint_range(0.1, 10.0) = 2.0; // Длительность паузы без мигания в секундах

void fragment() {
    vec4 base_color = COLOR;

    float time_in_cycle = TIME;

    float cycle_duration = blink_duration + no_blink_duration;
    float time_in_period = mod(time_in_cycle, cycle_duration);

    float blink_factor = 1.0;

    if (time_in_period < blink_duration) {
        // Фаза мигания
        float blink_value = abs(sin(TIME * blink_speed * PI));
        blink_factor = 1.0 + blink_value * blink_intensity;
    } else {
        // Фаза паузы (не мигаем)
        blink_factor = 1.0;
    }

    COLOR = base_color * blink_factor;
}