--幻星集月亮
function c66060018.initial_effect(c)
	  aux.EnablePendulumAttribute(c)
--pscale
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c66060018.sccon1)
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
	e2:SetCondition(c66060018.sccon2)
	e2:SetValue(4)
	c:RegisterEffect(e2)
	local e9=e2:Clone()
	e9:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e9)
--p
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,66050018)
	e3:SetCondition(c66060018.sccon1)
	e3:SetCost(c66060018.hxjcost)
	e3:SetTarget(c66060018.postg)
	e3:SetOperation(c66060018.posop)
	c:RegisterEffect(e3)
local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SSET)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCondition(c66060018.sccon2)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(1,0)
	e4:SetTarget(aux.TRUE)
	c:RegisterEffect(e4)
--summon
local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_POSITION)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetOperation(c66060018.activate)
	c:RegisterEffect(e5)
local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_DECKDES)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCountLimit(1,66060018)
	e7:SetTarget(c66060018.grave)
	e7:SetOperation(c66060018.tograve)
	c:RegisterEffect(e7)
--cannot be material
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e10:SetValue(c66060018.splimit)
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
function c66060018.splimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x660)
end
function c66060018.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c66060018.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
end
function c66060018.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c66060018.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end

function c66060018.sccon1(e)
	return e:GetHandler()==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,0) 
end
function c66060018.sccon2(e)
	return e:GetHandler()==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,1) 
end
function c66060018.posfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c66060018.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,1)
	if a:GetCount()==0 then return end
	if chk==0 then return a:IsExists(c66060018.posfilter,1,nil) end
	Duel.SendtoExtraP(a,nil,REASON_COST)
end
function c66060018.hxjcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():GetControler()==e:GetHandler():GetOwner() then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c66060018.hxjlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) end
end
function c66060018.hxjlimit(e,c)
	return not c:IsSetCard(0x660)
end
function c66060018.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,1)
	if a:GetCount()==0 then return end
	local c=e:GetHandler()
	if chk==0 then return a:IsExists(c66060018.posfilter,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c66060018.posop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,1)
	if a:GetCount()==0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoExtraP(a,nil,REASON_EFFECT)~=0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	end
end
function c66060018.grave(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
end
function c66060018.gravefilter(c,e,tp)
		return c:IsSetCard(0x660) and c:IsType(TYPE_PENDULUM)  and not c:IsType(TYPE_RITUAL) and c:IsAbleToGrave()
end
function c66060018.tograve(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=2 then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	local ct=g:GetCount()
	if ct>0 and g:FilterCount(c66060018.gravefilter,nil,e,tp)>0
		and Duel.SelectYesNo(tp,aux.Stringid(66060018,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=g:FilterSelect(tp,c66060018.gravefilter,1,1,nil,e,tp)
	local tc2=sg:GetFirst()
	if tc2 then
		Duel.SendtoGrave(tc2,REASON_EFFECT)
	end
	end
end
