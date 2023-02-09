--天使的次代圣光龙骑士
function c27822033.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)	
	--atk 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) end) 
	e1:SetValue(function(e) 
	return e:GetHandler():GetMaterial():GetSum(Card.GetAttack)/2 end) 
	c:RegisterEffect(e1)
	--atk limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET) 
	e1:SetValue(function(e,c)
	return c~=e:GetHandler() end) 
	c:RegisterEffect(e1)
	--immuse 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT) 
	e1:SetValue(function(e,te) 
	return te:IsActivated() and te:IsActiveType(TYPE_MONSTER) and te:GetHandler():GetAttack()<e:GetHandler():GetAttack() end)
	c:RegisterEffect(e1)	
	--Equip 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,27822033)
	e2:SetCondition(c27822033.eqcon)
	e2:SetTarget(c27822033.eqtg)
	e2:SetOperation(c27822033.eqop)
	c:RegisterEffect(e2)
	--to deck 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_LEAVE_FIELD_P)
	e3:SetOperation(c27822033.eqcheck)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCountLimit(1,17822033)
	e4:SetCondition(c27822033.tdcon)
	e4:SetTarget(c27822033.tdtg)
	e4:SetOperation(c27822033.tdop)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
c27822033.SetCard_XXLight=true 
function c27822033.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsControler(1-tp) 
end 
function c27822033.eqfil(c) 
	return c.SetCard_XXLight and c:IsType(TYPE_SYNCHRO) and not c:IsCode(27822033) and not c:IsForbidden() 
end 
function c27822033.eqtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c27822033.eqfil,tp,LOCATION_EXTRA+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED) 
end
function c27822033.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c27822033.eqfil,tp,LOCATION_EXTRA+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil) 
	if g:GetCount()>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		if not Duel.Equip(tp,tc,c) then return end
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(function(e,c)
		return e:GetOwner()==c end)
		tc:RegisterEffect(e1)
		local atk=tc:GetBaseAttack() 
		if atk>0 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE) 
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(atk)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2)
		end
	end 
end 
function c27822033.eqcheck(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject() then e:GetLabelObject():DeleteGroup() end
	local g=e:GetHandler():GetEquipGroup()
	g:KeepAlive()
	e:SetLabelObject(g)
end
function c27822033.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler():IsReason(REASON_BATTLE) or (e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():GetReasonPlayer()==1-tp))  
end 
function c27822033.tdfil(c) 
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)  
end 
function c27822033.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject():GetLabelObject() 
	if chk==0 then return g and g:IsExists(c27822033.tdfil,1,nil) end 
	local sg=g:Filter(c27822033.tdfil,nil) 
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
end 
function c27822033.tdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	if sg:GetCount()>0 then 
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end 
end 



