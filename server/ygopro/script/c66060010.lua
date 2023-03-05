--幻星集 命运之轮
function c66060010.initial_effect(c)
		c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
--pscale
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c66060010.sccon1)
	e1:SetValue(-3)
	c:RegisterEffect(e1)
	local e8=e1:Clone()
	e8:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e8)
local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_LSCALE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c66060010.sccon2)
	e2:SetValue(4)
	c:RegisterEffect(e2)
	local e9=e2:Clone()
	e9:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e9)
--spsummon condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(c66060010.splimit)
	c:RegisterEffect(e3)
--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,66060010)
	e4:SetCondition(c66060010.pencon)
	e4:SetTarget(c66060010.pentg)
	e4:SetOperation(c66060010.penop)
	c:RegisterEffect(e4)
--roof
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,66050010)
	e5:SetCondition(c66060010.condition)
	e5:SetTarget(c66060010.target)
	e5:SetOperation(c66060010.operation)
	c:RegisterEffect(e5)
--draw
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DRAW)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1,66050013)
	e6:SetCost(c66060010.hxjcost)
	e6:SetTarget(c66060010.rooftg)
	e6:SetOperation(c66060010.roofop)
	c:RegisterEffect(e6)
--set
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,66050004)
	e7:SetCondition(c66060010.scon)
	e7:SetTarget(c66060010.stg)
	e7:SetOperation(c66060010.sop)
	c:RegisterEffect(e7)
--cannot be material
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e10:SetValue(c66060010.splimit1)
	c:RegisterEffect(e10)
	local e11=e10:Clone()
	e11:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e11)
	local e12=e10:Clone()
	e12:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e12)
	local e13=e10:Clone()
	e13:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e13)
end
function c66060010.hxjcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():GetControler()==e:GetHandler():GetOwner() then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c66060010.hxjlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) end
end
function c66060010.hxjlimit(e,c)
	return not c:IsSetCard(0x660)
end
function c66060010.splimit1(e,c)
	if not c then return false end
	return not c:IsSetCard(0x660)
end
function c66060010.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x660) and not se:IsActiveType(TYPE_PENDULUM)
end
function c66060010.sccon1(e)
	return e:GetHandler()==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,0) 
end
function c66060010.sccon2(e)
	return e:GetHandler()==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,1) 
end
function c66060010.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c66060010.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c66060010.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c66060010.filter(c)
	return c:IsType(TYPE_PENDULUM+TYPE_FIELD+TYPE_SPELL) and c:IsSetCard(0x660) and c:IsAbleToHand()
end
function c66060010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>5 end
end
function c66060010.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<6 then return end
	local g=Duel.GetDecktopGroup(tp,6)
	Duel.ConfirmCards(tp,g)
	if g:IsExists(c66060010.filter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(66060010,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c66060010.filter,1,1,nil)
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		Duel.SortDecktop(tp,tp,5)
	else Duel.SortDecktop(tp,tp,6) end
end

function c66060010.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and re:GetHandler():IsCode(66060030) and not re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c66060010.scon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and Duel.GetFieldCard(tp,LOCATION_FZONE,0)==nil
end
function c66060010.stfilter(c,tp)
	return c:IsCode(66060030) and not c:IsForbidden()
end
function c66060010.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66060010.stfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp)
end
end
function c66060010.sop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c66060010.stfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local loc=tc:IsType(TYPE_FIELD) and LOCATION_FZONE or LOCATION_SZONE 
	Duel.MoveToField(tc,tp,tp,loc,POS_FACEUP,true)
	end
end
function c66060010.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_QUICK_F) and re:GetHandler():IsCode(66060030)
end
function c66060010.rooffilter(c)
	return c:IsSetCard(0x660) and not c:IsCode(66060010) and c:IsType(TYPE_PENDULUM)
end
function c66060010.rooftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66060010.rooffilter,tp,LOCATION_DECK,0,1,nil) end
end
function c66060010.roofop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c66060010.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,SEQ_DECKTOP)
			Duel.ConfirmDecktop(tp,1)
		end
	end
end