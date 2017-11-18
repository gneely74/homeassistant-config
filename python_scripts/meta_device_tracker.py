# Combine multiple device trackers into one entity
# You can call the script using the following:
# - service: python_script.meta_device_tracker
#   data_template:
#     entity_id: '{{trigger.entity_id}}'

# OPTIONS
# List the trackers for each individual
KateTrackers = ['device_tracker.katesiphone4','device_tracker.kates_iphone']
GradyTrackers = ['device_tracker.pi_gradys_iphone','device_tracker.gradysiphone']
# Get the entity that triggered the automation
triggeredEntity = data.get('entity_id')

# Set friendly name and the metatracker name based on the entity that triggered
if triggeredEntity in GradyTrackers:
    newFriendlyName = 'Grady Tracker'
    newEntityPicture = '/local/grady.png'
    metatrackerName = 'device_tracker.meta_grady'
elif triggeredEntity in KateTrackers:
    newFriendlyName = 'Kate Tracker'
    newEntityPicture = '/local/kate.png'
    metatrackerName = 'device_tracker.meta_kate'
else:
    newFriendlyName = None
    metatrackerName = None

# Get current & new state
newState = hass.states.get(triggeredEntity)
currentState = hass.states.get(metatrackerName)
# Get New data
newSource = newState.attributes.get('source_type')
newFriendlyName_temp = newState.attributes.get('friendly_name')

# If GPS source, set new coordinates
if newSource == 'gps':
    newLatitude = newState.attributes.get('latitude')
    newLongitude = newState.attributes.get('longitude')
    newgpsAccuracy = newState.attributes.get('gps_accuracy')
# If not, keep last known coordinates
elif currentState.attributes.get('latitude') is not None:
    newLatitude = currentState.attributes.get('latitude')
    newLongitude = currentState.attributes.get('longitude')
    newgpsAccuracy = currentState.attributes.get('gps_accuracy')
# Otherwise return null
else:
    newLatitude = None
    newLongitude = None
    newgpsAccuracy = None

# Get Battery
if newState.attributes.get('battery') is not None:
    newBattery = newState.attributes.get('battery')
elif currentState.attributes.get('battery') is not None:
    newBattery = currentState.attributes.get('battery')
else:
    newBattery = None

# Get velocity
if newState.attributes.get('velocity') is not None:
    newVelocity = newState.attributes.get('velocity')
elif currentState.attributes.get('velocity') is not None:
    newVelocity = currentState.attributes.get('velocity')
else:
    newVelocity = None

if newState.state is not None:
    newStatus = newState.state
else:
    newStatus = currentState.state

# Create device_tracker.meta entity
hass.states.set(metatrackerName, newStatus, {
    'friendly_name': newFriendlyName,
    'entity_picture': newEntityPicture,
    'source_type': newSource,
    'battery': newBattery,
    'gps_accuracy': newgpsAccuracy,
    'latitude': newLatitude,
    'longitude': newLongitude,
    'velocity': newVelocity,
    'update_source': triggeredEntity
})
