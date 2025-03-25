shader_type canvas_item;

uniform float step_size : hint_range(0.01, 0.5) = 0.005;          // Размер шага
uniform float speed_multiplier : hint_range(0.1, 10.0) = 2.0;     // Контроль скорости
uniform float amplitude : hint_range(0.0, 2.0) = 0.02;            // Амплитуда движения (максимальная дистанция)

void vertex() {
	float base_movement = cos(1.0) * sin(TIME * speed_multiplier / 2.0) * amplitude;

	float stepped_movement = floor(base_movement / step_size) * step_size;

	VERTEX.y += tan(stepped_movement) / sin(VERTEX.y);
}