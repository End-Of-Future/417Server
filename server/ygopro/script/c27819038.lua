--圣光再临
function c27819038.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,27819038+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c27819038.target)
	e1:SetOperation(c27819038.activate)
	c:RegisterEffect(e1)
	--to deck 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(c27819038.tdop)
	c:RegisterEffect(e2) 
	--destroy sub
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP) 
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3) 
	--atklimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_CANNOT_ATTACK) 
	c:RegisterEffect(e3)  
	--actlimit 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_CANNOT_TRIGGER) 
	c:RegisterEffect(e3) 
	--destroy
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c27819038.descon)
	e4:SetTarget(c27819038.destg)
	e4:SetOperation(c27819038.desop)
	c:RegisterEffect(e4)
end 
c27819038.SetCard_XXLight=true  
function c27819038.spfilter(c,e,tp)
	return c.SetCard_XXLight and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_ATTACK)
end
function c27819038.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c27819038.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c27819038.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c27819038.eqlimit(e,c)
	return e:GetLabelObject()==c
end
function c27819038.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
		Duel.Equip(tp,c,tc)
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c27819038.eqlimit)
		e1:SetLabelObject(tc)
		c:RegisterEffect(e1) 
	end
	Duel.SpecialSummonComplete()
end
function c27819038.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetHandler():GetEquipTarget()
	if tc then 
	Duel.Hint(HINT_CARD,0,27819038)
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c27819038.xdfilter(c,tp) 
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp)
end
function c27819038.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c27819038.xdfilter,1,nil,tp) and e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
end
function c27819038.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c27819038.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end







