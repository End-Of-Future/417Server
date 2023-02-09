--五王圣殿
function c27819057.initial_effect(c)
	 c:EnableCounterPermit(0x9ef)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27819057,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCost(c27819057.spcost)
	e1:SetTarget(c27819057.target)
	e1:SetOperation(c27819057.activate)
	c:RegisterEffect(e1)


	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c27819057.tg)
	e3:SetValue(c27819057.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)

	
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetOperation(c27819057.ctop)
	c:RegisterEffect(e5)
	
end
c27819057.SetCard_fiveking=true
c27819057.counter_add_list={0x9ef}

function c27819057.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x9ef,2,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x9ef,2,REASON_COST)
end
function c27819057.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
		and (Duel.IsExistingMatchingCard(c27819057.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1))
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c27819057.filter2(c,e,tp,mc,rk)
	return (c:IsRank(rk) or c:IsRank(rk-1))and c.SetCard_fiveking and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c27819057.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c27819057.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c27819057.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c27819057.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c27819057.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c27819057.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end

function c27819057.ctfilter(c)
	return c:IsFaceup() and c.SetCard_fiveking and c:IsSummonType(SUMMON_TYPE_XYZ) and c:IsSummonPlayer(tp)
end
function c27819057.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c27819057.ctfilter,1,nil) then
		e:GetHandler():AddCounter(0x9ef,1)
	end
end
function c27819057.tg(e,c)
	return c:IsFaceup() and c.SetCard_fiveking and c:IsType(TYPE_MONSTER)
end
function c27819057.atkval(e,c)
	return e:GetHandler():GetCounter(0x9ef)*200
end