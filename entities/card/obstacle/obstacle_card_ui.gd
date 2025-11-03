class_name ObstacleCardUI
extends CardUI



@onready var title_label := %TitleLabel
@onready var summary: Summary = %Summary



func set_obstacle_resource(obstacle_resource_: ObstacleResource) -> void:
	obstacle_resource = obstacle_resource_
	title_label.text = obstacle_resource.title
	summary.title = obstacle_resource.title
	summary.update_labels()
	
	match obstacle_resource_.title:
		"волшебница":
			title_label.text = "[tornado radius=5.0 freq=3.0][rainbow freq=0.5 sat=0.8 val=0.8 speed=1.0]{text}[/rainbow][/tornado]".format({"text": obstacle_resource.title})
		"девушка":
			title_label.text = "[color=fuchsia][i]{text}[/i][/color]".format({"text": obstacle_resource.title})
		"коршун":
			title_label.text = "[bird freq=3 index=3 vertical_size=3]{text}[/bird]".format({"text": obstacle_resource.title})
		"кукушка":
			title_label.text = "[bird freq=3 index=4 vertical_size=3]{text}[/bird]".format({"text": obstacle_resource.title})
		"кошка":#baseline,baseline,1 ко[table=1,bottom,top][cell]ш[/cell][/table]ка"  
			title_label.text = "[cat freq=3 index=2 vertical_size=3]{text}[/cat]".format({"text": obstacle_resource.title})
		"малыш":
			title_label.text = "[baby]{text}[/baby]".format({"text": obstacle_resource.title})
		"мошенник":
			title_label.text = "[thief duration=7]{text}[/thief]".format({"text": obstacle_resource.title})
		"мушкетер":
			title_label.text = "[soldier duration]{text}[/soldier]".format({"text": obstacle_resource.title})
		"мышь":
			title_label.text = "[mouse freq=10 amp=3 off=0.1]{text}[/mouse]".format({"text": obstacle_resource.title})
		"петушок":
			title_label.text = "[bird freq=3 index=4 vertical_size=3]{text}[/bird]".format({"text": obstacle_resource.title})
		"хищник":
			title_label.text = "[shake rate=20.0 level=5 connected=1]{text}[/shake]".format({"text": obstacle_resource.title})
		"шаман":
			title_label.text = "[mashroom freq=0.5]{text}[/mashroom]".format({"text": obstacle_resource.title})
		"швея":
			title_label.text = "[needle freq=20 amp=5 off=0.1]{text}[/needle]".format({"text": obstacle_resource.title})
		"шут":
			title_label.text = "[slinky freq=2 grade=5]{text}[/slinky]".format({"text": obstacle_resource.title})
		
